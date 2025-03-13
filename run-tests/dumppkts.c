#include <pcap.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

/*
 * 
 */
void process_packet (const struct pcap_pkthdr *header, const uint8_t *packet) {
  printf("%d\n", header->len) ;
}
//#############################################################################

int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Usage: %s <pcap>\n", argv[0]) ;
    return 1 ;
  }

  char errbuf[PCAP_ERRBUF_SIZE] ;
  pcap_t *handle = pcap_open_offline(argv[1], errbuf) ;
  if (!handle) {
    fprintf(stderr, "Error opening pcap file: %s\n", errbuf) ;
    return 1 ;
  }

  struct pcap_pkthdr *header ;
  const uint8_t *packet ;
  int res ;
  while((res = pcap_next_ex(handle, &header, &packet)) == 1){
    process_packet(header, packet) ;
  }

  if (res == -1){
    fprintf(stderr, "error\n") ;
  }

  pcap_close(handle) ;
  return 0 ;
}
