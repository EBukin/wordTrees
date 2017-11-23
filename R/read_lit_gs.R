#' Read gs with data


read_lit_gs <-
  function(sheetKey = "1J-m0ZZuhMPY9sKgxSVM5twEDXn_CCVPCUnIiM59R3cg") {
    g_sheet <- gs_key(sheetKey)
    gs_read(
      g_sheet,
      col_types = cols(
        Timestamp = col_character(),
        `ID-LINK` = col_character(),
        `Full reference: APA style` = col_character(),
        `Reference code: Autor et al. (YEAR). Title ... (Shortened)` = col_character(),
        `Keywords (separated by semicolon)` = col_character(),
        `Takeaway message` = col_character(),
        `Question tags` = col_character(),
        `Methodology tags` = col_character(),
        `Data tags` = col_character(),
        `Summary message` = col_character(),
        `Question description` = col_character(),
        `Methodology description` = col_character(),
        `Data description` = col_character(),
        `Results tags` = col_character(),
        `Results description` = col_character(),
        `Further readings: (APA style)` = col_character(),
        Topic = col_character()
      )
    ) %>%
      rename(
        link = `ID-LINK`,
        fullRef = `Full reference: APA style`,
        # Timestamp = Timestamp,
        idName = `Reference code: Autor et al. (YEAR). Title ... (Shortened)`,
        readBy = `Submitted by:`,
        idFull = `Full reference: APA style`,
        message = `Takeaway message`,
        keyWords = `Keywords (separated by semicolon)`,
        questTags = `Question tags`,
        methTags = `Methodology tags`,
        dataTags = `Data tags`,
        summaryMsg = `Summary message`,
        topic = Topic,
        quest = `Question description`,
        meth = `Methodology description`,
        reas = `Results description`,
        data =   `Data description`,
        restTags = `Results tags`,
        readings = `Further readings: (APA style)`#,
        # `Merged Doc ID - Compile a document`,
        # `Merged Doc URL - Compile a document`,
        # `Link to merged Doc - Compile a document`,
        # `Document Merge Status - Compile a document`
      ) %>% 
      select(idName, idFull, link, Timestamp, readBy, message, keyWords, questTags,
             methTags, dataTags, summaryMsg, topic, quest, meth, reas, data, 
             restTags, readings)
  }
