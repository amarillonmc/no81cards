--SB-555 faiz·加速形态
function c9980455.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,c9980455.matfilter2,c9980455.matfilter1,1,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9980455.sprcon)
	e2:SetOperation(c9980455.sprop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c9980455.val)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980455,2))
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c9980455.spcon)
	e4:SetTarget(c9980455.sptg)
	e4:SetOperation(c9980455.spop)
	c:RegisterEffect(e4)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9980455,5))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c9980455.spcon2)
	e6:SetCost(c9980455.spcost)
	e6:SetTarget(c9980455.sptg)
	e6:SetOperation(c9980455.spop)
	c:RegisterEffect(e6)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980455.sumsuc)
	c:RegisterEffect(e8)
end
function c9980455.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980455,0)) 
end 
function c9980455.matfilter1(c)
	return (c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)) or c:IsRace(RACE_FAIRY)
end
function c9980455.matfilter2(c)
	return c:IsFusionSetCard(0x9bca)
end
function c9980455.spfilter(c,fc)
	return (c:IsFusionSetCard(0x9bca) or ((c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)) or c:IsRace(RACE_FAIRY)))
		and c:IsCanBeFusionMaterial(fc) 
end
function c9980455.spfilter1(c,tp,g)
	return g:IsExists(c9980455.spfilter2,1,c,tp,c)
end
function c9980455.spfilter2(c,tp,mc)
	return (c:IsFusionSetCard(0x9bca) and ((mc:IsFusionAttribute(ATTRIBUTE_DARK) and mc:IsRace(RACE_WARRIOR)) or mc:IsRace(RACE_FAIRY)))
		or (((c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)) or c:IsRace(RACE_FAIRY)) and mc:IsFusionSetCard(0x9bca))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c9980455.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp):Filter(c9980455.spfilter,nil,c)
	return g:IsExists(c9980455.spfilter1,1,nil,tp,g)
end
function c9980455.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp):Filter(c9980455.spfilter,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=g:FilterSelect(tp,c9980455.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=g:FilterSelect(tp,c9980455.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	local cg=g1:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c9980455.val(e,c)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())*300
end
function c9980455.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9980455.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c9980455.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function c9980455.spfilter0(c,e,tp)
	return c:IsSetCard(0x9bca) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9980455.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and chkc:IsControler(tp) and c9980455.spfilter0(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9980455.spfilter0,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9980455.spfilter0,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9980455.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980455,1)) 
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end