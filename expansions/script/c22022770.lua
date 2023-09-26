--人理之灵 沙条爱歌
function c22022770.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xff1),aux.NonTuner(Card.IsSetCard,0xff1),1)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetCondition(c22022770.atkcon)
	e1:SetValue(5000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	--take control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022770,0))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22022770)
	e3:SetTarget(c22022770.target)
	e3:SetOperation(c22022770.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--change effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22022770,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,22022771)
	e5:SetCondition(c22022770.chcon)
	e5:SetTarget(c22022770.chtg)
	e5:SetOperation(c22022770.chop)
	c:RegisterEffect(e5)
end
function c22022770.filter0(c)
	return c:IsFaceup() and c:IsSetCard(0x2ff1)
end
function c22022770.atkcon(e)
	return Duel.IsExistingMatchingCard(c22022770.filter0,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c22022770.filter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsControlerCanBeChanged(true)
end
function c22022770.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c22022770.filter,nil,tp)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount()-1 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c22022770.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	Duel.GetControl(g,tp)
end
function c22022770.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and (re:IsActiveType(TYPE_MONSTER)
		or (re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c22022770.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c22022770.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22022770.repop)
end
function c22022770.filter1(c,e,sp)
	return c:IsSetCard(0x2ff1) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c22022770.repop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(c22022770.filter1,1-tp,LOCATION_DECK,0,nil,e,tp)
	if cg:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(1-tp,aux.Stringid(22022770,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=cg:Select(1-tp,1,1,nil)
			Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
