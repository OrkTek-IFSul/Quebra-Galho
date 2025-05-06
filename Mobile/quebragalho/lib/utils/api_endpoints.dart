class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'http://localhost:8080/api';

    // Avaliações
  static String criarAvaliacao(int agendamentoId) => '/avaliacoes/$agendamentoId';
  static String getAvaliacoesServico(int servicoId) => '/avaliacoes/servico/$servicoId';
  static String deletarAvaliacao(int id) => '/avaliacoes/$id';

  // Usuários
  static String getUsuario(int id) => '/usuarios/$id';
  static String atualizarUsuario(int id) => '/usuarios/$id';
  static String deletarUsuario(int id) => '/usuarios/$id';
  static const String getUsuarios = '/usuarios';
  static const String criarUsuario = '/usuarios';
  static String uploadImagemUsuario(int id) => '/usuarios/$id/imagem';
  static String removerImagemUsuario(int id) => '/usuarios/$id/removerimagem';

  // Tags
  static String atualizarStatusTag(int id) => '/tags/$id/status';
  static const String getTags = '/tags';
  static const String criarTag = '/tags';
  static String getTag(int id) => '/tags/$id';


  // Serviços
  static String atualizarServico(int id) => '/servicos/$id';
  static String deletarServico(int id) => '/servicos/$id';
  static String criarServico(int prestadorId) => '/servicos/$prestadorId';
  static const String getServicos = '/servicos';
  static String getServicosPorPrestador(int prestadorId) => '/servicos/prestador/$prestadorId';

  // Tags de Prestadores
  static String atualizarTagPrestador(int tagId, int prestadorId) => '/tag-prestador/$tagId/$prestadorId';
  static String deletarTagPrestador(int tagId, int prestadorId) => '/tag-prestador/$tagId/$prestadorId';
  static String getTagPrestador(int prestadorId) => '/tag-prestador/prestador/$prestadorId';

  // Agendamentos
  static const String criarAgendamento = '/agendamentos';
  static String getAgendamentosUsuario(int usuarioId) => '/agendamentos/usuario/$usuarioId';
  static String getAgendamentosPrestador(int prestadorId) => '/agendamentos/prestador/$prestadorId';
  static String deletarAgendamento(int id) => '/agendamentos/$id';

  // Prestadores
  static String getPrestador(int id) => '/prestadores/$id';
  static String atualizarPrestador(int id) => '/prestadores/$id';
  static String deletarPrestador(int id) => '/prestadores/$id';
  static String criarPrestador(int usuarioId) => '/prestadores/$usuarioId';
  static const String getPrestadores = '/prestadores';

  // Respostas
  static String atualizarRespostas(int id) => '/respostas/$id';
  static String deletarRespostas(int id) => '/respostas/$id';
  static String criarRespostas(int avaliacaoId) => '/respostas/$avaliacaoId';
  static String getRespostas(int avaliacaoId) => '/respostas/avaliacao/$avaliacaoId';
  
  // Denúncias
  static String atualizarDenuncias(int id) => '/denuncias/$id/resolver';
  static const String criarDenuncias = '/denuncias/';
  static const String getDenuncias = '/denuncias/pendentes/';
  
  //Portfolio
  static String criarPortfolio(int prestadorId) => '/portfolio/$prestadorId';
  static String getPortfolio(int prestadorId) => '/portfolio/prestador/$prestadorId';
  static String deletarPortfolio(int id) => '/portfolio/$id';

  //Tags de Serviços
  static String criarTagServico(int tagId, int servicoId) => '/tag-servico/$tagId/$servicoId';
  static String deletarTagServico(int tagId, int servicoId) => '/tag-servico/$tagId/$servicoId';
  static String getTagServico(int servicoId) => '/tag-servico/servico/$servicoId';

  //Apelos
  static String atualizarApelo(int id) => '/apelos/$id/resolver';
  static String criarApelo(int denunciaId) => '/apelos/$denunciaId';
  static String getApelo(int id) => '/apelos/$id';
  static const String getApelos = '/apelos/pendentes';
}