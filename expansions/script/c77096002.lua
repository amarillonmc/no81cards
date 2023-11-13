--灰姑娘 伊丽莎白
function c77096002.initial_effect(c)
	aux.AddCodeList(c,72283691)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetCountLimit(1,77096002)
	e1:SetTarget(c77096002.eqtg)
	e1:SetOperation(c77096002.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--xx	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(77096002)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c77096002.adop)
	c:RegisterEffect(e2)
end
function c77096002.filter(c)
	return c:IsCode(77096003) and not c:IsForbidden()
end
function c77096002.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c77096002.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c77096002.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c77096002.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc and Duel.Equip(tp,tc,c) and Duel.IsEnvironment(72283691,PLAYER_ALL,LOCATION_FZONE) and Duel.IsExistingMatchingCard(function(c) return c:IsCode(77096004) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,1,nil) then
		local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(77096004) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)  
	end
end 
function c77096002.filsn(c)
	return c:IsOriginalCodeRule(72283691) and c:IsFaceup()
		and not c:GetFlagEffectLabel(77096002)
end
function c77096002.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ng=Duel.GetMatchingGroup(c77096002.filsn,tp,LOCATION_FZONE,LOCATION_FZONE,nil)
	local nc=ng:GetFirst()
	while nc do
		nc:RegisterFlagEffect(77096002,RESETS_STANDARD,0,1)  
		local id=nc:ReplaceEffect(nc:GetOriginalCode(),0)  
		nc=ng:GetNext()
	end
end
if not c77096002.yy_mtchk then 
	c77096002.yy_mtchk=true 
	_rge=Card.RegisterEffect 
	function Card.RegisterEffect(c,ie,ob) --ReplaceEffect
		local b=ob or false
		if not (c:IsOriginalCodeRule(72283691))
			or not (ie:IsHasType(EFFECT_TYPE_FIELD) and ie:IsHasType(EFFECT_TYPE_CONTINUOUS)) then  
			return _rge(c,ie,b) 
		end  
		local x=0
		if ie:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then 
			ie:SetProperty(ie:GetProperty()-EFFECT_FLAG_UNCOPYABLE) 
			x=1 
		end 
		ie:SetOperation(c77096002.yymtop)
		local n1=_rge(c,ie,b) 
		if x==1 then 
			ie:SetProperty(ie:GetProperty()+EFFECT_FLAG_UNCOPYABLE) 
		end 
		return n1
	end
end 
function c77096002.yymtop(e,tp,eg,ep,ev,re,r,rp) 
	local x=10 
	if Duel.IsPlayerAffectedByEffect(tp,77096002) then x=5 end 
	local g=Duel.GetDecktopGroup(tp,x)
	if g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==x then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end  
end

