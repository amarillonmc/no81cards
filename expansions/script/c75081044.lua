--烈光的黑之牙 索尼娅
function c75081044.initial_effect(c)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetTarget(c75081044.sumtg)
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75081044,0))
	e4:SetCategory(CATEGORY_SUMMON+CATEGORY_DISABLE_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_SUMMON)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,75081044)
	e4:SetCondition(c75081044.discon)
	e4:SetTarget(c75081044.distg)
	e4:SetOperation(c75081044.disop)
	c:RegisterEffect(e4)  
	local e6=e4:Clone()
	e6:SetDescription(aux.Stringid(75081044,5))
	e6:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e6)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75081044,1))
	e3:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,75081046)
	e3:SetTarget(c75081044.sptg)
	e3:SetOperation(c75081044.spop)
	c:RegisterEffect(e3)	
end
--
function c75081044.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c75081044.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)  end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c75081044.sumtg(e,c)
	return c:IsType(TYPE_MONSTER) and c~=e:GetHandler() and c:IsSetCard(0xa754)
end
function c75081044.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end  
	Duel.NegateSummon(eg) 
	local s1=c:IsSummonable(true,nil,1)
	local s2=c:IsMSetable(true,nil,1)
	if (s1 and s2 and Duel.SelectPosition(tp,c,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
		Duel.Summon(tp,c,true,nil,1)
	else
		Duel.MSet(tp,c,true,nil,1) 
	end
end
--
function c75081044.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c75081044.filter(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) and c:IsSetCard(0xa754)
end
function c75081044.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c75081044.filter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75081044,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g1=Duel.SelectMatchingCard(tp,c75081044.filter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g1:GetFirst()
		if tc then
			local s1=tc:IsSummonable(true,nil,1)
			local s2=tc:IsMSetable(true,nil,1)
			if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
				Duel.Summon(tp,tc,true,nil,1)
			else
				Duel.MSet(tp,tc,true,nil,1)
			end
		end  
	end
end