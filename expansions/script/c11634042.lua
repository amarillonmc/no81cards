local s,id,o=GetID()
function s.initial_effect(c)
	local e_ac_1=Effect.CreateEffect(c)
	e_ac_1:SetCategory(CATEGORY_RELEASE+CATEGORY_DRAW)
	e_ac_1:SetType(EFFECT_TYPE_ACTIVATE)
	e_ac_1:SetCode(EVENT_SUMMON_SUCCESS)
	e_ac_1:SetProperty(EFFECT_FLAG_DELAY)
	e_ac_1:SetCountLimit(1,id)
	e_ac_1:SetCondition(s.con)
	e_ac_1:SetTarget(s.target)
	e_ac_1:SetOperation(s.activate)
	c:RegisterEffect(e_ac_1)
	local e_ac_2=e_ac_1:Clone()
	e_ac_2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e_ac_2)
	local e_th=Effect.CreateEffect(c)
	e_th:SetDescription(aux.Stringid(id,0))
	e_th:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e_th:SetType(EFFECT_TYPE_QUICK_O)
	e_th:SetRange(LOCATION_GRAVE)
	e_th:SetCode(EVENT_FREE_CHAIN)
	e_th:SetCountLimit(1,id)
	e_th:SetCondition(s.thcon)
	e_th:SetCost(aux.bfgcost)
	e_th:SetTarget(s.thtg)
	e_th:SetOperation(s.thop)
	c:RegisterEffect(e_th)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(s.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,c:GetCode()) then
		c:RegisterFlagEffect(id,RESET_EVENT+0x4fe0000,0,1)
	end
end
function s.cfilter(c)
	return c:IsSetCard(0x119) and c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.filter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsSummonPlayer(1-tp) and c:IsReleasableByEffect()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter,1,nil,tp) end
	local g=eg:Filter(s.filter,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,g:GetCount(),0,0)
end
function s.sf(c,seq,p)
	local cp=c:GetControler()
	return (cp==p and aux.MZoneSequence(c:GetSequence())==seq) or (cp~=p and aux.MZoneSequence(c:GetSequence())==4-seq)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain():Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if g:GetCount()==0 or Duel.Release(g,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup()
	local cg=Group.CreateGroup()
	for tc in aux.Next(og) do
		local seq,p=aux.MZoneSequence(tc:GetPreviousSequence()),tc:GetPreviousControler()
		local tseq=seq
		if p~=tp then tseq=4-seq end
		if e:GetHandler():GetSequence()==tseq or Duel.IsExistingMatchingCard(function(c,seq)return c:GetFlagEffect(id)>0 and aux.MZoneSequence(c:GetSequence())==seq end,tp,LOCATION_MZONE,0,1,nil,tseq) then cg:Merge(Duel.GetMatchingGroup(s.sf,tp,LOCATION_MZONE,LOCATION_MZONE,nil,seq,p)) end
	end
	local ct=math.floor(cg:GetSum(Card.GetAttack)/1000)
	if ct>0 then Duel.Draw(tp,ct,REASON_EFFECT) end
end
function s.lfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x119) and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetFlagEffect(id)~=0
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.thfilter(c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
