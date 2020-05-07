library(DT)






  
  
  server <- function(input, output, session) {
    source("download.R")
    
    output$table <- DT::renderDT({ 
      ##exampe of reactivness (dentro de table)
      
        DT::datatable(tabla,
                      options = list(pageLength = 200,
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
        'nome', 'Status',
        backgroundColor = styleEqual(c("O QUESTIONÁRIO FOI CONCLUIDO COM SUCESSO",
                                       "A CHAMADA FOI INTERROMPIDA ANTES DE CONCLUIR O QUESTIONÁRIO",
                                       "@ PARTICIPANTE NAO ATENDEU A CHAMADA", 
                                       "@S NUMEROS DO PARTICIPANTE NAO CHAMAM",
                                       "@ PARTICIPANTE SE RECUSA DE FALAR COM A NOSSA EQUIPA",
                                       "NO FINAL DO PROCESSO NAO CONSEGUIMOS ENTREVISTAR @ PARTICIPANTE"),  
                                     c('#88d8b0', #green
                                       '#ffeead', 
                                       '#ffeead', #amarelo 
                                       '#ffeead', 
                                       '#FF6F69',#rojo
                                       "#FF6F69"))) %>%
        formatStyle(
          'has__errors',
          backgroundColor = styleInterval(
            c(0, Inf), c(NA, "#FF6F69","#FF6F69")
            )
        )
        
      
      })
        
      
    
    
    
  }