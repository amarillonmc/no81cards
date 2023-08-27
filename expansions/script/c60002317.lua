--朝阳与落日的余晖·神光
local cm,m,o=GetID()
cm.name="朝阳与落日的余晖·神光"
cm.tab = { }
--cm.tab[tp]={ }
--cm.tab[1-tp]={ }
function cm.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--pzone set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetOperation(cm.mvop)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetOperation(cm.mvop2)
	c:RegisterEffect(e3)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.seqtg)
	e2:SetOperation(cm.seqop)
	c:RegisterEffect(e2)
end
function cm.filter0(c)
	return c:IsAttack(1320) and c:IsDefense(1450) and not c:IsForbidden()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:GetEquipTarget() and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.IsExistingMatchingCard(cm.filter0,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		if Duel.IsExistingMatchingCard(cm.filter0,tp,LOCATION_HAND,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			Duel.DiscardHand(tp,cm.filter0,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local player=c:GetControler()
	local seq = c:GetSequence()
	if seq==5 then seq=1
	elseif seq==6 then seq=3 end
	if not cm.tab[player] then cm.tab[player] = { } end
	if not cm.CheckKeyIsInTable(cm.tab[player],seq) then table.insert(cm.tab[player],seq) end
end
function cm.mvop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local player=c:GetControler()
	local seq = c:GetSequence()
	cm.tab[tp]={}
	cm.tab[1-tp]={}
end
function cm.CheckKeyIsInTable(tab,key)
	if key==nil then return false end
	for k, v in pairs(tab) do
		if v == key then
			return true
		end
	end
	return false
end
function cm.seqfilter(c)
	return c:IsFaceup() and c:IsAttack(1320) and c:IsDefense(1450)
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.seqfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 and Duel.IsExistingTarget(cm.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	Duel.SelectTarget(tp,cm.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	if Duel.MoveSequence(tc,nseq)~=0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
		if #g~=0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.filter(c)
	local tp=c:GetControler()
	local seq=c:GetSequence()
	if seq==5 and not c:IsLocation(LOCATION_MZONE) then return false end
	if cm.tab[0] then
		local pseq = seq
		if tp~=0 then pseq=4-seq end
		Debug.Message(pseq)
		if cm.CheckKeyIsInTable(cm.tab[0],pseq) then return true end
	elseif cm.tab[1] then
		local pseq = seq
		if tp~=1 then pseq=4-seq end
		if cm.CheckKeyIsInTable(cm.tab[1],pseq) then return true end
	end
	return false
end
