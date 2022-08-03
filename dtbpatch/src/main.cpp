/*
 * Copyright (c) 2020 Fabio Belavenuto <belavenuto@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */
/*
 * Quick and dirty devicetree patcher
 */

#include <cstring>
#include <iostream>
#include <string>
#include <map>
#include <fstream>
#include <vector>
#include <list>

const uint32_t FDT_BEGIN_NODE = 1;
const uint32_t FDT_END_NODE = 2;
const uint32_t FDT_PROP = 3;
const uint32_t FDT_NOP = 4;
const uint32_t FDT_END = 9;

#pragma pack(push, 1)
struct fdt_header {
    uint32_t magic;
    uint32_t totalsize;
    uint32_t off_dt_struct;
    uint32_t off_dt_strings;
    uint32_t off_mem_rsvmap;
    uint32_t version;
    uint32_t last_comp_version;
    uint32_t boot_cpuid_phys;
    uint32_t size_dt_strings;
    uint32_t size_dt_struct;
};
#pragma pack(pop)

/*****************************************************************************/
class Property {
    private:
        std::string name;
        char value[1024];
        int size;
    public:
        Property(char* name, char* valuePtr, int valueSize) {
            this->name = name;
            this->size = valueSize;
            memcpy(this->value, valuePtr, valueSize);
        }
        Property(const Property& p) {
            this->name = p.name;
            this->size = p.size;
            memcpy(this->value, p.value, p.size);
        }
        Property& operator=(const Property& p) {
            if (&p != this) {
                this->~Property();
                new (this) Property(p);
            }
            return *this;
        }
        std::string getName() {
            return this->name;
        }
        char* getValue() {
            return this->value;
        }
        int getValueSize() {
            return this->size;
        }
        void setValue(const char* valuePtr, int valueSize) {
            this->size = valueSize;
            memcpy(this->value, valuePtr, valueSize);
        }
};

/*****************************************************************************/
class Node {
    private:
      std::string name;
      int size = 0;
      std::list<Property*> properties;
      std::list<Node*> childNodes;
    public:
        Node(const std::string name) {
            this->name = name;
        }
        Node(const Node& n) {
            this->name = n.name;
            this->size = n.size;
            for (auto &it: n.properties) {
                this->properties.push_back(new Property(*it));
            }
            for (auto &it: n.childNodes) {
                this->childNodes.push_back(new Node(*it));
            }
        }
        Node& operator=(Node const& n) {
            if (&n != this) {
                this->~Node();
                new (this) Node(n);
            }
            return *this;
        }
        void addProperty(Property* property) {
            this->properties.push_back(property);
        }
        void addNode(Node* node) {
            this->childNodes.push_back(node);
        }
        std::string getName() {
            return this->name;
        }
        void setName(const std::string name) {
            this->name = name;
        }
        std::list<Property*> getProperties() {
            return this->properties;
        }
        std::list<Node*>* getChildNodes() {
            return &this->childNodes;
        }
        Node* popChildNode() {
            if (this->childNodes.size() == 0) {
                return NULL;
            }
            Node* node = this->childNodes.front();
            this->childNodes.pop_front();
            return node;
        }
        std::list<Node*>::iterator eraseChildNode(std::list<Node*>::iterator node) {
            return childNodes.erase(node);
        }
};

std::vector<uint64_t> resMem;
std::map<std::string, int> strings;
Node *rootNode;
int led=0, internal_slot=1;

/*****************************************************************************/
uint32_t changeEndian(uint32_t num) {
    return ((num>>24)&0xff)       | // move byte 3 to byte 0
           ((num<<8)&0xff0000)    | // move byte 1 to byte 2
           ((num>>8)&0xff00)      | // move byte 2 to byte 1
           ((num<<24)&0xff000000);  // move byte 0 to byte 3
}

/*****************************************************************************/
int parseDtb(char* fileName) {
    struct fdt_header header;
    
    std::ifstream file(fileName);
    if (!file) {
        std::cerr << "Could not open " << fileName << std::endl;
        return -1;
    }
    file.read(reinterpret_cast<char*>(&header), sizeof(struct fdt_header));

    if (changeEndian(header.magic) != 0xD00DFEED) {
        std::cerr << "Magic error" << std::endl;
        return -1;
    }
    if (changeEndian(header.version) != 17) {
        std::cerr << "Version != 17" << std::endl;
        return -1;
    }

    int size = changeEndian(header.totalsize);
    int offsetStruct = changeEndian(header.off_dt_struct);
    int sizeStruct = changeEndian(header.size_dt_struct);
    int offsetString = changeEndian(header.off_dt_strings);
    int sizeString = changeEndian(header.size_dt_strings);
    // read memory reservation entries
    uint64_t rme1, rme2;
    while (true) {
        file.read(reinterpret_cast<char*>(&rme1), sizeof(uint64_t));
        file.read(reinterpret_cast<char*>(&rme2), sizeof(uint64_t));
        resMem.push_back(rme1);
        resMem.push_back(rme2);
        if (rme1 == 0 && rme2 == 0) {
            break;
        }
    }
    // read strings
    char strBlock[sizeString];
    file.seekg(offsetString);
    file.read(strBlock, sizeString);
    
    uint32_t t, cnt=0, nameSize, propSize, propOff;
    char c, pc[1024];
    bool loop = true, flag;
    file.seekg(offsetStruct);
    Node *lastNode;
    std::vector<Node*> nodes;
    std::string s = "";
    while (loop) {
        file.read(reinterpret_cast<char*>(&t), sizeof(uint32_t));
        uint32_t token = changeEndian(t);
        switch (token) {
            // Begin node
            case FDT_BEGIN_NODE:
              // Read node name
              flag = true;
              s = "";
              while (flag) {
                cnt = sizeof(uint32_t);
                while (cnt > 0) {
                    file.read(&c, 1);
                    if (c == 0) {
                        flag = false;
                    } else {
                        s += c;
                    }
                    --cnt;
                }
              }
              rootNode = new Node(s);
              nodes.push_back(rootNode);
              break;

            // End node
            case FDT_END_NODE:
                // Remove last node from vector
                rootNode = nodes.back();
                nodes.pop_back();
                // If not root node
                if (nodes.size() > 0) {
                    lastNode = nodes.back();
                    lastNode->addNode(rootNode);
                }
                break;

            // Property
            case FDT_PROP:
                file.read(reinterpret_cast<char*>(&t), sizeof(uint32_t));
                propSize = changeEndian(t);   // size of value
                file.read(reinterpret_cast<char*>(&t), sizeof(uint32_t));
                propOff = changeEndian(t);    // strings offset
                // Alignment
                t = propSize;
                if ((t % 4) != 0) {
                    t += (4 - (t % 4));
                }
                // read value
                file.read(pc, t);
                rootNode->addProperty(new Property((strBlock + propOff), pc, propSize));
                break;

            // Nop, ignore
            case FDT_NOP:
              break;

            // End of struct
            case FDT_END:
              loop = false;
              break;

            default:
              std::cerr << "Token not recognized" << std::endl;
              loop = false;
              break;
        }
    }
    file.close();
    return 0;
}

/*****************************************************************************/
void recursiveNodes(Node* node) {
    std::list<Property*> props = node->getProperties();
    while (props.size() > 0) {
        Property* prop = props.front();
        props.pop_front();
        std::string s = prop->getName();
        auto it = strings.find(s);
        if (it == strings.end()) {
            strings.emplace(s, 0);
        }
    }
    std::list<Node*>* childs = node->getChildNodes();
    for (auto &i : *childs) {
        recursiveNodes(i);
    }
}

/*****************************************************************************/
void recursiveNodes(Node* node, std::ofstream *outFile) {
    uint32_t token = changeEndian(FDT_BEGIN_NODE);
    outFile->write(reinterpret_cast<char*>(&token), sizeof(uint32_t));
    std::string s = node->getName();
    size_t ss = s.size()+1;
    outFile->write(s.c_str(), ss);
    if ((ss % 4) != 0) {
        ss = (4 - (ss % 4));
        token = 0;
        outFile->write(reinterpret_cast<char*>(&token), ss);
    }
    std::list<Property*> props = node->getProperties();
    while (props.size() > 0) {
        Property* prop = props.front();
        props.pop_front();
        token = changeEndian(FDT_PROP);
        outFile->write(reinterpret_cast<char*>(&token), sizeof(uint32_t));
        uint32_t size = changeEndian(prop->getValueSize());
        outFile->write(reinterpret_cast<char*>(&size), sizeof(uint32_t));
        uint32_t so = changeEndian(strings[prop->getName()]);
        outFile->write(reinterpret_cast<char*>(&so), sizeof(uint32_t));
        so = prop->getValueSize();
        outFile->write(prop->getValue(), so);
        if ((so % 4) != 0) {
            so = (4 - (so % 4));
            token = 0;
            outFile->write(reinterpret_cast<char*>(&token), so);
        }
        delete prop;
    }
    while (true) {
        Node* childNode = node->popChildNode();
        if (childNode == NULL) {
            break;
        }
        recursiveNodes(childNode, outFile);
        delete childNode;
        token = changeEndian(FDT_END_NODE);
        outFile->write(reinterpret_cast<char*>(&token), sizeof(uint32_t));
    }
}

/*****************************************************************************/
int remountDtb(char *fileName) {
    struct fdt_header header;

    // remount file
    std::ofstream outFile(fileName);
    if (!outFile) {
        std::cerr << "Could not open " << fileName << " to write" << std::endl;
        return -1;
    }
    outFile.write(reinterpret_cast<char*>(&header), sizeof(struct fdt_header));
    size_t memOffset = outFile.tellp();
    uint64_t rme1, rme2;
    while (true) {
        rme1 = resMem.front();
        resMem.erase(resMem.begin());
        rme2 = resMem.front();
        resMem.erase(resMem.begin());
        outFile.write(reinterpret_cast<char*>(&rme1), sizeof(uint64_t));
        outFile.write(reinterpret_cast<char*>(&rme2), sizeof(uint64_t));
        if (rme1 == 0 && rme2 == 0) {
            break;
        }
    }
    // get all strings
    int stringsOffset = 0;
    recursiveNodes(rootNode);
    for (auto &i: strings) {
        i.second = stringsOffset;
        stringsOffset += i.first.size()+1;
    }
    size_t structOffset = outFile.tellp();
    recursiveNodes(rootNode, &outFile);
    uint32_t token = changeEndian(FDT_END_NODE);    // root node
    outFile.write(reinterpret_cast<char*>(&token), sizeof(uint32_t));
    token = changeEndian(FDT_END);
    outFile.write(reinterpret_cast<char*>(&token), sizeof(uint32_t));
    size_t strOffset = outFile.tellp();
    for (auto &i: strings) {
        outFile.write(i.first.c_str(), i.first.size()+1);
    }
    size_t fileSize = outFile.tellp();
    outFile.seekp(0);
    header.magic = changeEndian(0xD00DFEED);
    header.totalsize = changeEndian(fileSize);
    header.off_dt_struct = changeEndian(structOffset);
    header.off_dt_strings = changeEndian(strOffset);
    header.off_mem_rsvmap = changeEndian(memOffset);
    header.version = changeEndian(17);
    header.last_comp_version = changeEndian(16);
    header.boot_cpuid_phys = 0;
    header.size_dt_strings = changeEndian(fileSize - strOffset);
    header.size_dt_struct = changeEndian(strOffset - structOffset);
    outFile.write(reinterpret_cast<char*>(&header), sizeof(struct fdt_header));
    outFile.close();
    return 0;
}

/*****************************************************************************/
void changeInternalNode(Node* node, const char* root, uint32_t port) {
    std::string s;

    // change properties of subnodes
    std::list<Node*>* nodesInt = node->getChildNodes();
    for (auto &it: *nodesInt) {
        s = it->getName();
        if (s.compare("ahci") == 0) {
            std::list<Property*> propsAhci = it->getProperties();
            for (auto &it2: propsAhci) {
                s = it2->getName();
                if (s.compare("pcie_root") == 0) {
                    it2->setValue(root, strlen(root)+1);
                } else if (s.compare("ata_port") == 0) {
                    uint32_t v = changeEndian(port);
                    it2->setValue(reinterpret_cast<const char*>(&v), 4);
                }
            }
        } else if (s.compare("led_green") == 0 || s.compare("led_orange") == 0) {
            std::list<Property*> propsLed = it->getProperties();
            for (auto &it2: propsLed) {
                s = it2->getName();
                if (s.compare("led_name") == 0) {
                    s = "syno_led" + std::to_string(led++);
                    it2->setValue(s.c_str(), s.size()+1);
                }
            }
        } else if (s.compare("mv14xx") == 0) {
            std::list<Property*> propsAhci = it->getProperties();
            for (auto &it2: propsAhci) {
                s = it2->getName();
                if (s.compare("pcie_root") == 0) {
                    it2->setValue(root, strlen(root)+1);
                } else if (s.compare("phy") == 0) {
                    uint32_t v = changeEndian(port);
                    it2->setValue(reinterpret_cast<const char*>(&v), 4);
                }
            }
        }
    }
}

/*****************************************************************************/
void changeNvmeNode(Node* node, const char* root) {
    std::string s;

    std::list<Property*> propsNvme = node->getProperties();
    for (auto &it: propsNvme) {
        s = it->getName();
        if (s.compare("pcie_root") == 0) {
            it->setValue(root, strlen(root)+1);
        }
    }
}

/*****************************************************************************/
int main(int argc, char **argv) {
    if (argc < 3) {
        std::cerr << "Use: dtbpatch <model.dtb> <model_patched.dtb>" << std::endl;
        return 1;
    }
    int r=parseDtb(argv[1]);
    if (r) return r;
    // patch nodes
    std::string s;
    Node* internal1 = NULL; // copy from first internal_slot node
    Node* nvme1 = NULL;     // copy from first nvme_slot node
    std::list<Node*>* childs(rootNode->getChildNodes());
    auto it = (*childs).begin();
    while(it != (*childs).end()) {
        s = (*it)->getName();
        // check if is a internal_slot@x
        if (s.find("internal_slot") != std::string::npos) {
            if (NULL == internal1) {
                internal1 = new Node(*(*it));           // copy it
            }
            it = rootNode->eraseChildNode(it);          // remove it
        } else if (s.find("nvme_slot") != std::string::npos) {
            if (NULL == nvme1) {
                nvme1 = new Node(*(*it));               // copy it
            }
            it = rootNode->eraseChildNode(it);          // remove it
        } else {
            ++it;
        }
    }
    int c = 1;
    std::string pciepath;
    uint32_t ata_port_no=0;
    char buffer[1024];

    while (internal1) {
        s = "/sys/block/sata" + std::to_string(c++) + "/device/syno_block_info";
        std::ifstream inFile(s);
        if (!inFile) {
            break;
        }
        std::cout << s << std::endl;
        while (inFile.good()) {
            inFile.getline(buffer, 1024);
            s = buffer;
            if (s.find("pciepath=") != std::string::npos) {
                pciepath = s.substr(9);
            } else if (s.find("ata_port_no=") != std::string::npos) {
                ata_port_no = std::stoi(s.substr(12));
            }
        }
        std::cout << pciepath << " - " << ata_port_no << std::endl;
        s = "internal_slot@" + std::to_string(internal_slot++);
        Node* nnode = new Node(*internal1);
        nnode->setName(s);
        changeInternalNode(nnode, pciepath.c_str(), ata_port_no);
        rootNode->addNode(nnode);
        inFile.close();
    }
    c = 0;
    int nvme_slot=1;
    while (nvme1) {
        s = "/sys/block/nvme" + std::to_string(c++) + "n1/device/syno_block_info";
        std::ifstream inFile(s);
        if (!inFile) {
            break;
        }
        std::cout << s << std::endl;
        while (inFile.good()) {
            inFile.getline(buffer, 1024);
            s = buffer;
            if (s.find("pciepath=") != std::string::npos) {
                pciepath = s.substr(9);
            }
        }
        std::cout << pciepath << std::endl;
        s = "nvme_slot@" + std::to_string(nvme_slot++);
        Node* nnode = new Node(*nvme1);
        nnode->setName(s);
        changeNvmeNode(nnode, pciepath.c_str());
        rootNode->addNode(nnode);
        inFile.close();
    }
    // remount
    r=remountDtb(argv[2]);
    return r;
}
