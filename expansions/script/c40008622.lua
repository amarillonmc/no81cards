--爆裂No.0 未来皇 霍普·未来
function c40008622.initial_effect(c)
	c:EnableCounterPermit(0x30)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(c40008622.spcon)
	e1:SetOperation(c40008622.spop)
	c:RegisterEffect(e1)
	--atk def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c40008622.value)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--destroy all
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40008622,0))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c40008622.cttg)
	e4:SetOperation(c40008622.ctop)
	c:RegisterEffect(e4) 
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5) 
	--attack all
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_ATTACK_ALL)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(40008622,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c40008622.tdcon)
	e6:SetCost(c40008622.thcost)
	e6:SetTarget(c40008622.sptg1)
	e6:SetOperation(c40008622.spop1)
	c:RegisterEffect(e6)
	--Special summon2
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(40008622,2))
	e7:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCondition(c40008622.spcon2)
	e7:SetTarget(c40008622.sptg2)
	e7:SetOperation(c40008622.spop2)
	c:RegisterEffect(e7)
end
c40008622.xyz_number=0
c40008622.card_code_list={80280737}
c40008622.card_code_list={65305468}
function c40008622.spcostfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_ONFIELD)) and c:IsAbleToGraveAsCost()
		and c:IsCode(80280737,65305468)
end
c40008622.spcost_list={80280737,65305468}
function c40008622.spcost_selector(c,tp,g,sg,i)
	if not c:IsCode(c40008622.spcost_list[i]) then return false end
	sg:AddCard(c)
	g:RemoveCard(c)
	local flag=false
	if i<2 then
		flag=g:IsExists(c40008622.spcost_selector,1,nil,tp,g,sg,i+1)
	else
		flag=Duel.GetMZoneCount(tp,sg,tp)>0
	end
	sg:RemoveCard(c)
	g:AddCard(c)
	return flag
end
function c40008622.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c40008622.spcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	return g:IsExists(c40008622.spcost_selector,1,nil,tp,g,sg,1)
end
function c40008622.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c40008622.spcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=g:FilterSelect(tp,c40008622.spcost_selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	local tc=sg:GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		if tc:IsOnField() and tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
	Duel.SendtoGrave(sg,REASON_COST)
end
end
function c40008622.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x30)
end
function c40008622.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x30,2)
	end
end
function c40008622.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,0,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)*500
end
function c40008622.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0 or e:GetHandler():GetAttackedCount()>0
end
function c40008622.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x30,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x30,1,REASON_COST)
end
function c40008622.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008622.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c40008622.spfilter1(chkc,e,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c40008622.spfilter1,tp,0,LOCATION_GRAVE,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c40008622.spfilter1,tp,0,LOCATION_GRAVE,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c40008622.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c40008622.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c40008622.spfilter2(c,e,tp)
	return c:IsCode(65305468) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008622.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40008622.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c40008622.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c40008622.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c40008622.xyzfilter(c)
	return c:IsType(TYPE_MONSTER) 
end
function c40008622.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.SelectYesNo(tp,aux.Stringid(40008622,3)) then
			local tg=Duel.SelectMatchingCard(tp,c40008622.xyzfilter,tp,LOCATION_GRAVE,0,1,2,nil)
			Duel.Overlay(tc,tg)
	end
end