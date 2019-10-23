--狱火机 拿非利
function c40008715.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c40008715.lcheck)
	c:EnableReviveLimit()   
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e2:SetCondition(c40008715.spcon)
	e2:SetOperation(c40008715.spop)
	c:RegisterEffect(e2) 
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008715,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c40008715.setop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40008715,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetCost(c40008715.rmcost)
	e4:SetTarget(c40008715.rmtg)
	e4:SetOperation(c40008715.rmop)
	c:RegisterEffect(e4)
end
function c40008715.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_SPSUMMON)
end
function c40008715.spfilter(c)
	return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c40008715.sumfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c40008715.link(c)
	if c:IsType(TYPE_LINK) then return c:GetLink() end
end
function c40008715.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local sum=Duel.GetMatchingGroup(c40008715.sumfilter,tp,LOCATION_MZONE,0,nil):GetSum(c40008715.link)
	if sum>4 then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-1 then return false end
	if c:IsHasEffect(34822850) then
		if ft>0 then
			return Duel.IsExistingMatchingCard(c40008715.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,2,c)
		else
			local ct=-ft+1
			return Duel.IsExistingMatchingCard(c40008715.spfilter,tp,LOCATION_MZONE,0,ct,nil)
				and Duel.IsExistingMatchingCard(c40008715.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,2,c)
		end
	else
		return ft>0 and Duel.IsExistingMatchingCard(c40008715.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,c)
	end
end
function c40008715.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if c:IsHasEffect(34822850) then
		if ft>0 then
			g=Duel.SelectMatchingCard(tp,c40008715.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,2,2,c)
		else
			local sg=Duel.GetMatchingGroup(c40008715.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,c)
			local ct=-ft+1
			g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
			if ct<2 then
				sg:Sub(g)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g2=sg:Select(tp,1,1,nil)
				g:Merge(g2)
			end
		end
	else
		g=Duel.SelectMatchingCard(tp,c40008715.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,2,c)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c40008715.setfilter(c)
	return c:IsSetCard(0xc5) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end
function c40008715.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c40008715.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		if tc:IsType(TYPE_QUICKPLAY) or tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		end
		Duel.ConfirmCards(1-tp,g)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c40008715.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c40008715.splimit(e,c)
	return not c:IsSetCard(0xbb)
end
function c40008715.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsReleasable,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsReleasable,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c40008715.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c40008715.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end