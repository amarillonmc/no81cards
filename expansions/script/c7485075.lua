--魔导法皇的神金像
local s,id,o=GetID()
local m=id
local cm=_G["c"..m]

cm.named_with_God_Gold=1

function cm.God_Gold(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_God_Gold
end

function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetCode(EFFECT_SPSUMMON_PROC)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e01:SetValue(SUMMON_TYPE_RITUAL)
	e01:SetCondition(cm.spcon)
	e01:SetOperation(cm.spcop)
	c:RegisterEffect(e01)
	--special summon
	local e02=Effect.CreateEffect(c)
	e02:SetDescription(aux.Stringid(m,0))
	e02:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e02:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e02:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e02:SetCode(EVENT_TO_GRAVE)
	e02:SetCountLimit(1,m)
	e02:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		local ge1=Effect.CreateEffect(e:GetHandler())
		ge1:SetDescription(aux.Stringid(m,5))
		ge1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		ge1:SetType(EFFECT_TYPE_SINGLE)
		local ge01=Effect.CreateEffect(e:GetHandler())
		ge01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge01:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge01:SetTargetRange(0xff,0)
		ge01:SetTarget(function(e,c)
			return c:IsCode(7485075) 
		end)
		ge01:SetLabelObject(ge1)
		Duel.RegisterEffect(ge01,tp)
	end)
	e02:SetTarget(cm.target)
	e02:SetOperation(cm.operation)
	c:RegisterEffect(e02)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCost(cm.GGcost)
	e1:SetTarget(cm.destg1)
	e1:SetOperation(cm.desop1)
	c:RegisterEffect(e1)
	--destroy
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetTarget(cm.destg2)
	e2:SetOperation(cm.desop2)
	c:RegisterEffect(e2)
	--[[--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(52085075,0))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetTarget(c52085075.atktarget)
	e5:SetOperation(c52085075.activate)
	c:RegisterEffect(e5)
	--place
	local e6=e5:Clone()
	e6:SetDescription(aux.Stringid(52085075,1))
	e6:SetTarget(c52085075.thtg)
	e6:SetOperation(c52085075.thop)
	c:RegisterEffect(e6)]]
end
function cm.lv(c)
	return 7
end
function cm.spcfilter(c,e,tp)
	return c==e:GetHandler()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local m1=Duel.GetRitualMaterial(tp)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:RemoveCard(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,8,"Greater")
	local res=mg:CheckSubGroup(aux.RitualCheck,1,8,tp,c,8,"Greater")
	aux.GCheckAdditional=nil
	return res
end
function cm.spcop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if not c then return false end
	local mg=Duel.GetRitualMaterial(tp)
	mg:RemoveCard(c)
	if c then
		local mg=mg:Filter(Card.IsCanBeRitualMaterial,c,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(c,8,"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,8,tp,c,8,"Greater")
		aux.GCheckAdditional=nil
		c:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
	end
end
function cm.hintfilter(c,id)
	return c:GetOriginalCode()==id
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.hintfilter,tp,0xff,0,nil,m)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(0,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	end
end
function cm.filter(c,e,sp)
	return c:IsFaceup() and cm.God_Gold(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,sp,false,true)
end
function cm.filter2(c,e,sp)
	return c:IsCode(7485071) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,sp,false,true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_SZONE,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp))
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE+LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function cm.gcheck(g)
	if g:FilterCount(Card.IsLocation,nil,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE)>0 then 
		return g:FilterCount(Card.IsLocation,nil,LOCATION_SZONE)<=0 and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE)<=1 
	end
	if g:FilterCount(Card.IsLocation,nil,LOCATION_SZONE)>0 then 
		return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE)<=0
	end
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_SZONE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter2),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local g=Group.__add(g1,g2)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,cm.gcheck,false,1,ct)
	Duel.SpecialSummon(sg,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
end
function cm.costfilter(c)
	return cm.God_Gold(c) and c:IsAbleToGraveAsCost()
end
function cm.GGcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.cfilter(c)
	return cm.God_Gold(c)
end
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_GRAVE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
end
function cm.desfilter2(c)
	return cm.God_Gold(c)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:FilterCount(cm.desfilter2,nil)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if ct>0 and sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=sg:Select(tp,1,ct,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
		Duel.BreakEffect()
	end
	Duel.SortDecktop(tp,tp,5)
end
--[[function c52085075.spcfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGraveAsCost()
end
function c52085075.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c52085075.spcfilter,tp,LOCATION_MZONE,0,2,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
end
function c52085075.spcop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c52085075.spcfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c52085075.filter(c,e,sp)
	return c:IsFaceup() and c:IsSetCard(0x133) and c:IsCanBeSpecialSummoned(e,0,sp,true,false)
end
function c52085075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c52085075.filter,tp,LOCATION_SZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local gct=Duel.GetMatchingGroupCount(c52085075.filter,tp,LOCATION_SZONE,0,nil,e,tp)
	if ct>gct then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,gct,tp,LOCATION_SZONE)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,LOCATION_SZONE)
	end
end
function c52085075.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local g=Duel.GetMatchingGroup(c52085075.filter,tp,LOCATION_SZONE,0,nil,e,tp)
	local gc=g:GetCount()
	if gc==0 then return end
	if gc<=ct then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ct,ct,nil)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c52085075.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,0x133)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c52085075.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,0x133)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		Duel.RaiseEvent(tc,EVENT_CUSTOM+47408488,e,0,tp,0,0)
	end
end

function c52085075.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c52085075.atktarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c52085075.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c52085075.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c52085075.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c52085075.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(52085075,RESET_EVENT+0x1220000+RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(52085075,0))
		e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetLabelObject(tc)
		e2:SetCondition(c52085075.shcon)
		e2:SetTarget(c52085075.shtg)
		e2:SetOperation(c52085075.shop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c52085075.shcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return eg:IsContains(tc) and tc:GetFlagEffect(52085075)~=0
end
function c52085075.shfilter(c)
	return c:IsSetCard(0x133) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c52085075.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c52085075.shfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c52085075.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c52085075.shfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end]]
