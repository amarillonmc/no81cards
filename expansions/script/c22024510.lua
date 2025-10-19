--人理保障 芙芙
function c22024510.initial_effect(c)
	--spsummon hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22024510,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22024510)
	e1:SetCondition(c22024510.hspcon1)
	e1:SetTarget(c22024510.hsptg1)
	e1:SetOperation(c22024510.hspop1)
	c:RegisterEffect(e1)
	--spsummon hand 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22024510,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,22024510)
	e2:SetCondition(c22024510.spcon1)
	e2:SetOperation(c22024510.spop1)
	c:RegisterEffect(e2)

	--spsummon deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22024510,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_DECK)
	e3:SetCountLimit(1,22024510)
	e3:SetCondition(c22024510.hspcon2)
	e3:SetTarget(c22024510.hsptg2)
	e3:SetOperation(c22024510.hspop2)
	c:RegisterEffect(e3)
	--spsummon deck 2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22024510,1))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_DECK)
	e4:SetCountLimit(1,22024510)
	e4:SetCondition(c22024510.spcon2)
	e4:SetOperation(c22024510.spop2)
	c:RegisterEffect(e4)
	--nontuner
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e5:SetCode(EFFECT_NONTUNER)
	e5:SetValue(c22024510.tnval)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22024510,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1,22024511)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c22024510.spcost)
	e6:SetTarget(c22024510.dlvtg)
	e6:SetOperation(c22024510.dlvop)
	c:RegisterEffect(e6)
	--special summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22024510,3))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1,22024511)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCondition(c22024510.erecon)
	e7:SetCost(c22024510.erecost)
	e7:SetTarget(c22024510.dlvtg)
	e7:SetOperation(c22024510.dlvop)
	c:RegisterEffect(e7)
end
c22024510.effect_with_avalon=true
function c22024510.hspfilter1(c,tp)
	return c:IsSetCard(0x5098) and Duel.GetMZoneCount(tp,c)>0
end
function c22024510.hspcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c22024510.hspfilter1,1,REASON_SPSUMMON,false,nil,tp)
end
function c22024510.hsptg1(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c22024510.hspfilter1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c22024510.hspop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function c22024510.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(tp,1,0,0xfee,3,REASON_COST)
end
function c22024510.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0xfee,3,REASON_COST)
end

function c22024510.hspfilter2(c,tp)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SYNCHRO) and Duel.GetMZoneCount(tp,c)>0
end
function c22024510.hspcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c22024510.hspfilter2,1,REASON_SPSUMMON,false,nil,tp)
end
function c22024510.hsptg2(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c22024510.hspfilter2,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c22024510.hspop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function c22024510.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(tp,1,0,0xfee,12,REASON_COST)
end
function c22024510.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0xfee,12,REASON_COST)
end
function c22024510.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c22024510.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22024510.sfilter(c,e,tp,lv)
	return c:IsLevelBelow(10) and c:IsSetCard(0xff1)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22024510.dlvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lv=e:GetHandler():GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22024510.sfilter(chkc,e,tp,lv) end
	if chk==0 then return lv>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22024510.sfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22024510.sfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22024510.dlvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and c:IsRelateToEffect(e)
		and c:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(tc:GetOriginalLevel())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
	end
end
function c22024510.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end

function c22024510.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end