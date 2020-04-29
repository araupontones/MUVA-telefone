library(DT)


source("download.R")


  
  
  server <- function(input, output, session) {
   
    
    output$table <- DT::renderDT({ 
      ##exampe of reactivness (dentro de table)
      
        DT::datatable(tabla,
                      options = list(pageLength = 25,
                                     #LengthChange = F,
                                     #columnDefs = list(list(orderable=F, targets=c(0))),
                                     # dom = 't',
                                     # scrollY = 'calc(100vh - 150px)',
                                     
                                     language = list(
                                       zeroRecords = "Neste distrito ainda não há agentes",
                                       search = "Pesquisar",
                                       lengthMenu = "Mostrar_MENU_observações",
                                       info = "Mostrando _START_ a _END_ de _TOTAL_ entradas")
                                     
                                     
                      ),
                      selection = 'none',
                      rownames = FALSE,
                      escape = F
                      #colnames = c("")
        ) %>%formatStyle(
        'Nome', 'Status',
        backgroundColor = styleEqual(c("O QUESTIONÁRIO FOI CONCLUIDO COM SUCESSO",
                                       "A CHAMADA FOI INTERROMPIDA ANTES DE CONCLUIR O QUESTIONÁRIO",
                                       "@ PARTICIPANTE NAO ATENDEU A CHAMADA", 
                                       "@S NUMEROS DO PARTICIPANTE NAO CHAMAM",
                                       "@ PARTICIPANTE SE RECUSA DE FALAR COM A NOSSA EQUIPA",
                                       "NO FINAL DO PROCESSO NAO CONSEGUIMOS ENTREVISTAR @ PARTICIPANTE"),  
                                     c('#88d8b0', #green
                                       '#ffeead', 
                                       '#ffeead', #amarelo 
                                       '#ffeead', #rojo
                                       '#FF6F69',
                                       "#FF6F69")))         
        
      
      })
        
      
    
    
    
  }