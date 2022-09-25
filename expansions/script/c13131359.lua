--奥西里斯的天空龙-神之盾 
if not aux.rgxchk then
	aux.rgxchk=true
	_rge=Card.RegisterEffect 
	function Card.RegisterEffect(c,ie,ob) --ReplaceEffect   
		local b=ob or false  
		if (not c:IsCode(10000020))
			or (not ie:IsHasType(EFFECT_TYPE_SINGLE)) or (ie:GetCondition()==nil) or (ie:GetOperation()==nil) then  
			return _rge(c,ie,b) 
		end  
		local n1=_rge(c,ie,b) 
		local qe=ie:Clone()  
		local con=ie:GetCondition()  
		qe:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)   
		return Duel.IsPlayerAffectedByEffect(tp,13131359)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.GetFlagEffect(tp,13131359)==0  
		end) 
		qe:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)  
		Duel.RegisterFlagEffect(tp,13131359,RESET_PHASE+PHASE_END,0,2) 
		end) 
		qe:SetDescription(aux.Stringid(13131359,1))
		local n2=_rge(c,qe,b)
		return n1,n2
	end
end
local m=13131359
local cm=_G["c"..m] 
function c13131359.initial_effect(c)  
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13131359,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c13131359.ttcon)
	e1:SetOperation(c13131359.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1) 
	--Negate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c13131359.nscon) 
	e1:SetTarget(c13131359.nstg)
	e1:SetOperation(c13131359.nsop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_IMMUNE_EFFECT) 
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE) 
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0) 
	e2:SetTarget(c13131359.immtg)
	e2:SetValue(c13131359.efilter)
	c:RegisterEffect(e2) 
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c13131359.adval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4) 
	--to hand 
	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,13131359)
	e5:SetCondition(c13131359.thcon) 
	e5:SetTarget(c13131359.thtg)   
	e5:SetOperation(c13131359.thop) 
	c:RegisterEffect(e5)  
end
function c13131359.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c13131359.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end  
function c13131359.nckfil(c,tp) 
	return c:IsOnField() and c:IsControler(tp)  
end 
function c13131359.nscon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end 
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c13131359.nckfil,nil,tp)-tg:GetCount()>0  
end  
function c13131359.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end
function c13131359.nsop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then 
	Duel.NegateEffect(ev)   
	end 
end
function c13131359.immtg(e,c) 
	return c:IsAttribute(ATTRIBUTE_DIVINE) and not c:IsCode(13131359)  
end  
function c13131359.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c13131359.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*1000
end
function c13131359.thcon(e,tp,eg,ep,ev,re,r,rp) 
	return rp==1-tp and e:GetHandler():IsPreviousControler(tp)  
end  
function c13131359.thfil(c) 
	return c:IsAbleToHand() and c:IsCode(10000020)   
end 
function c13131359.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c13131359.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end  
function c13131359.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c13131359.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg)  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(13131359) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)   
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)   
	if Duel.GetFlagEffect(tp,13131359)~=0 then 
	Duel.ResetFlagEffect(tp,13131359) 
	end 
	local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0xff,0xff,nil,10000020) 
	for tc in aux.Next(g) do
		if tc.initial_effect then
			local ini=c13131359.initial_effect
			c13131359.initial_effect=function() end
			tc:ReplaceEffect(13131359,0)
			c13131359.initial_effect=ini
			tc.initial_effect(tc)
		end 
	end 
	end 
end 
 









