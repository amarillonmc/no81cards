--柩机之兽 弗维
function c40009689.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c40009689.condition)
	c:RegisterEffect(e1) 
	--Summon Cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e2:SetCode(0x10000000+40009689)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SUMMON_COST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,0xff)
	e5:SetCondition(c40009689.costcon)
	e5:SetCost(c40009689.costchk)
	e5:SetOperation(c40009689.costop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e6)
	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009689,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,40009689)
	e3:SetCondition(c40009689.xyzcon1)
	e3:SetTarget(c40009689.xyztg)
	e3:SetOperation(c40009689.xyzop)
	c:RegisterEffect(e3)   
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c40009689.xyzcon2)
	c:RegisterEffect(e4)
end
function c40009689.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x1f17)
end
function c40009689.condition(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0
		and not Duel.IsExistingMatchingCard(c40009689.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c40009689.costcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0x1f17) and c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_MZONE)
end
function c40009689.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,m)
	return Duel.CheckLPCost(tp,ct*500)
end
function c40009689.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
function c40009689.xyzcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,0,1,nil) or Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_FZONE,1,nil)
end
function c40009689.xyzcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_FZONE,1,nil)
end
function c40009689.xyzfilter1(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return c:IsFaceup() and c:IsLevel(6) and c:IsSetCard(0x1f17)
		and Duel.IsExistingMatchingCard(c40009689.xyzfilter2,tp,LOCATION_EXTRA,0,1,nil,tp,mg)
end
function c40009689.xyzfilter2(c,tp,mg)
	return c:IsXyzSummonable(mg,2,2) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c40009689.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40009689.xyzfilter1(chkc,e,tp,c) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c40009689.xyzfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40009689.xyzfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_EXTRA)
end
function c40009689.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local mg=Group.FromCards(c,tc)
	local g=Duel.GetMatchingGroup(c40009689.xyzfilter2,tp,LOCATION_EXTRA,0,nil,tp,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,sg:GetFirst(),mg)
	end
end
