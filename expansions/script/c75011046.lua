--炼金工房剑客 派翠夏·阿贝尔海姆
function c75011046.initial_effect(c)
	aux.AddCodeList(c,46130346,5318639)
	--antica spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,75011046)
	e1:SetCondition(c75011046.spcon)
	e1:SetTarget(c75011046.sptg)
	e1:SetOperation(c75011046.spop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75011047)
	e2:SetCost(c75011046.damcost)
	e2:SetTarget(c75011046.damtg)
	e2:SetOperation(c75011046.damop)
	c:RegisterEffect(e2)
	if not c75011046.global_check then
		c75011046.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetCondition(c75011046.checkcon)
		ge1:SetOperation(c75011046.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c75011046.chkfilter(c,tp,rp)
	return c:IsPreviousControler(1-tp) and rp==tp or c:IsPreviousControler(tp) and rp==1-tp
end
function c75011046.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75011046.chkfilter,1,nil,tp,rp)
end
function c75011046.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,75011046,RESET_PHASE+PHASE_END,0,1)
end
function c75011046.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,75011046)>0
end
function c75011046.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75011046.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c75011046.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c75011046.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c75011046.thfilter(c)
	return c:IsCode(46130346,5318639) and c:IsAbleToGrave()
end
function c75011046.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c75011046.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #tg>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
