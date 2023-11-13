--湖 中 龙
local m=130006042
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,130006046)
	--bp sp 
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK)
	e0:SetCondition(c130006042.spcon)
	e0:SetOperation(c130006042.spop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c130006042.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK)
	e2:SetCondition(c130006042.sprcon)
	e2:SetOperation(c130006042.sprop)
	c:RegisterEffect(e2)
	--force direct
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c130006042.imcon)
	e3:SetValue(c130006042.imval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetProperty(0)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	e3:SetLabelObject(e4)
	--bp
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_BP)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(c130006042.bpcon)
	c:RegisterEffect(e5)
	--dere
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_DAMAGE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c130006042.drcon)
	e6:SetOperation(c130006042.drop)
	c:RegisterEffect(e6)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c130006042.sppcon)
	e6:SetTarget(c130006042.spptg)
	e6:SetOperation(c130006042.sppop)
	c:RegisterEffect(e6)
	
end
function c130006042.spcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and e:GetHandler():IsSpecialSummonable() and Duel.GetCurrentChain()==0
end
function c130006042.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummonRule(tp,e:GetHandler())
end
function c130006042.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c130006042.dafilter(c)
	return aux.IsCodeListed(c,130006046) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end
function c130006042.sprcon(e,c)
	local c=e:GetHandler()
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c130006042.dafilter,tp,LOCATION_ONFIELD,0,2,nil)
end
function c130006042.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c130006042.dafilter,tp,LOCATION_ONFIELD,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c130006042.im1filter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,130006046)
end
function c130006042.im2filter(c)
	return c:IsFacedown() or not aux.IsCodeListed(c,130006046)
end
function c130006042.imcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c130006042.im1filter,tp,LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(c130006042.im2filter,tp,LOCATION_MZONE,0,1,nil)
end
function c130006042.imval(e,c)
	return not c:IsImmuneToEffect(e:GetLabelObject())
end
function c130006042.bpcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)==0
end
function c130006042.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_BATTLE)~=0
end
function c130006042.thfilter(c)
	return c:IsFaceupEx() and Duel.IsExistingMatchingCard(c130006042.thfilter2,tp,LOCATION_GRAVE+LOCATION_DECK,LOCATION_GRAVE,2,nil,c:GetCode())
end
function c130006042.thfilter2(c,code)
	return c:IsAbleToHand() and c:IsCode(code)
end
function c130006042.thfilter3(c,codes)
	return c:IsAbleToHand() and Duel.IsExistingMatchingCard(c130006042.thfilter2,tp,LOCATION_GRAVE+LOCATION_DECK,LOCATION_GRAVE,2,nil,c:GetCode()) and c:IsCode(table.unpack(codes))
end
function c130006042.gcheck(g,e,tp)
	return g:GetClassCount(Card.GetCode)==1
end
function c130006042.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,2000,REASON_EFFECT)~=0 then
	local tg=Duel.GetMatchingGroup(c130006042.thfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	local ag=Group.CreateGroup()
	local codes={}
	for c in aux.Next(tg) do
		local code=c:GetCode()
		if not ag:IsExists(Card.IsCode,1,nil,code) then
			ag:AddCard(c)
			table.insert(codes,code)
		end
	end
	if tg:GetCount()>0 then
	local tgg=Duel.GetMatchingGroup(c130006042.thfilter3,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,codes)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=tgg:SelectSubGroup(tp,c130006042.gcheck,false,2,2,e,tp)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
	end
end
function c130006042.sppcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and rp==1-tp
end
function c130006042.sppfilter(c,e,tp)
	return aux.IsCodeListed(c,130006046) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c130006042.spptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c130006042.sppfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c130006042.sppop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c130006042.sppfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
