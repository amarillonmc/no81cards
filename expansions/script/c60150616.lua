--千夜 黑白
function c60150616.initial_effect(c)
	c:EnableReviveLimit()
	--fusion summon
	aux.AddFusionProcFunRep(c,c60150616.ffilter,2,true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c60150616.splimit)
	c:RegisterEffect(e1)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60150616,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c60150616.e4tg)
	e4:SetOperation(c60150616.e4op)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c60150616.adval)
	c:RegisterEffect(e5)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e7)
	
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(60150616,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,60150616)
	e6:SetCondition(c60150616.spcon)
	e6:SetTarget(c60150616.sptg)
	e6:SetOperation(c60150616.spop)
	c:RegisterEffect(e6)
end
function c60150616.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x3b21) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function c60150616.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c60150616.e1tg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c60150616.spfilter2(c)
	return c:IsSetCard(0x3b21) and c:IsCanBeFusionMaterial() and c:IsAbleToDeckOrExtraAsCost()
end
function c60150616.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c60150616.spfilter2,tp,LOCATION_MZONE,0,2,nil)
end
function c60150616.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c60150616.spfilter2,tp,LOCATION_MZONE,0,2,2,nil)
	local cg=g:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c60150616.tgfilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_PENDULUM)
end
function c60150616.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150616.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60150616.gfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c60150616.gfilter2(c)
	return c:IsAbleToGrave()
end
function c60150616.e4op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60150616.tgfilter,tp,LOCATION_DECK,0,nil)
	local g2=g:Filter(c60150616.gfilter,nil)
	local g3=g:Filter(c60150616.gfilter2,nil)
	if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150616,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150616,2))
		local sg=g2:Select(tp,1,1,nil)
		Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
	elseif g3:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g3:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	else 
		return false
	end
end
function c60150616.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)*800
end

function c60150616.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c60150616.spfilter(c,e,tp)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and ((c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0)
			or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end
function c60150616.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150616.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c60150616.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60150616.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end