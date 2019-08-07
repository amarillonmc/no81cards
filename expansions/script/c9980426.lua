--AgitΩ·三位一体
function c9980426.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9980426.ffilter,3,true)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9980426.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9980426.sprcon)
	e2:SetOperation(c9980426.sprop)
	c:RegisterEffect(e2)
	--fusion limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9980426)
	e2:SetOperation(c9980426.regop)
	c:RegisterEffect(e2)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980426.sumsuc)
	c:RegisterEffect(e8)
end
function c9980426.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980426,1))
end 
function c9980426.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c9980426.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x5bca) and c:IsType(TYPE_MONSTER) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function c9980426.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c9980426.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c9980426.sprfilter1(c,tp,fc)
	return c:IsFusionSetCard(0x5bca) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(c9980426.sprfilter2,tp,LOCATION_MZONE,0,1,c,tp,fc,c)
end
function c9980426.sprfilter2(c,tp,fc,mc)
	return c:IsFusionSetCard(0x5bca) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsFusionAttribute(mc:GetFusionAttribute())
		and Duel.IsExistingMatchingCard(c9980426.sprfilter3,tp,LOCATION_MZONE,0,1,c,tp,fc,mc,c)
end
function c9980426.sprfilter3(c,tp,fc,mc1,mc2)
	local g=Group.FromCards(c,mc1,mc2)
	return c:IsFusionSetCard(0x5bca) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsFusionAttribute(mc1:GetFusionAttribute()) and not c:IsFusionAttribute(mc2:GetFusionAttribute())
		and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function c9980426.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c9980426.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c9980426.sprfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=Duel.SelectMatchingCard(tp,c9980426.sprfilter3,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst(),g2:GetFirst())
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c9980426.thfilter(c)
	return c:IsSetCard(0x5bca) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9980426.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c9980426.thcon)
	e1:SetOperation(c9980426.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9980426.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9980426.thfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c9980426.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9980426)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9980426.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end