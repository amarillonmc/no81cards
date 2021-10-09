--风都侦探W-疾风加速极限
function c9980769.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c9980769.spcon)
	e1:SetOperation(c9980769.spop)
	c:RegisterEffect(e1)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980769,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9980769)
	e1:SetTarget(c9980769.drtg)
	e1:SetOperation(c9980769.drop)
	c:RegisterEffect(e1)
	--disable and destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(c9980769.disop)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980769.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980769.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980769,1))
end
function c9980769.spfilter1(c,ft,tp)
	if c:GetSequence()<5 then ft=ft+1 end
	return c:IsFaceup() and c:IsSetCard(0x3bc2) and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
		and ft>-1 and Duel.IsExistingMatchingCard(c9980769.spfilter2,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c9980769.spfilter2(c,ft)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsSetCard(0x3bc2) and c:IsAbleToRemove() and (ft>0 or c:GetSequence()<5)
end
function c9980769.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-2 and Duel.IsExistingMatchingCard(c9980769.spfilter1,tp,LOCATION_MZONE,0,1,nil,ft,tp)
end
function c9980769.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c9980769.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,ft,tp)
	local tc=g1:GetFirst()
	if tc:GetSequence()<5 then ft=ft+1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c9980769.spfilter2,tp,LOCATION_MZONE,0,1,1,nil,ft)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c9980769.tgfilter(c)
	return c:IsSetCard(0x9bc1) and c:IsAbleToGrave()
end
function c9980769.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c9980769.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9980769.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9980769.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980769,2))
	end
end
function c9980769.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) then return end
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980769,2))
	end
end