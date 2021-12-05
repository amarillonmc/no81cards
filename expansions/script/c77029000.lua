--PNC 帕斯卡
function c77029000.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,77029000)
	e1:SetCondition(c77029000.thcon)
	e1:SetCost(c77029000.thcost)
	e1:SetTarget(c77029000.thtg)
	e1:SetOperation(c77029000.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,77029000)
	e2:SetCost(c77029000.thcost)
	e2:SetTarget(c77029000.thtg)
	e2:SetOperation(c77029000.thop)
	c:RegisterEffect(e2)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_REMOVED)
	e3:SetTargetRange(1,0)
	e3:SetValue(c77029000.damval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,17029000)
	e5:SetCost(c77029000.rhcost)
	e5:SetTarget(c77029000.rhtg)
	e5:SetOperation(c77029000.rhop)
	c:RegisterEffect(e5)
end
c77029000.named_with_PNC=true 
function c77029000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c77029000.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local flag=Duel.GetFlagEffectLabel(tp,77029000) 
	if flag==nil then 
	Duel.RegisterFlagEffect(tp,77029000,0,0,0,1) 
	local te=Duel.IsPlayerAffectedByEffect(tp,77029000) 
	if te~=nil then 
	te:Reset() 
	end
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029000,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029000)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	else
	Duel.SetFlagEffectLabel(tp,77029000,flag+1) 
	local te=Duel.IsPlayerAffectedByEffect(tp,77029000) 
	if te~=nil then 
	te:Reset() 
	end
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029000,flag+1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029000)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	end 
end
function c77029000.thfil(c,flag)
	return c:IsLevelBelow(flag+1) and c:IsRace(RACE_CYBERSE) and c:IsAbleToHand() 
end
function c77029000.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local flag=Duel.GetFlagEffectLabel(tp,77029000) 
	if flag==nil then flag=0 end
	if chk==0 then return Duel.IsExistingMatchingCard(c77029000.thfil,tp,LOCATION_DECK,0,1,nil,flag) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,flag*500)
end
function c77029000.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=Duel.GetFlagEffectLabel(tp,77029000) 
	if flag==nil then return false end  
	local g=Duel.GetMatchingGroup(c77029000.thfil,tp,LOCATION_DECK,0,nil,flag-1) 
	if g:GetCount()>0 then  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	Duel.Damage(tp,flag*500,REASON_EFFECT) 
	if sg:GetFirst():IsSummonable(true,nil) and Duel.SelectYesNo(tp,aux.Stringid(77029000,0)) then
		Duel.BreakEffect()
		Duel.Summon(tp,sg:GetFirst(),true,nil)
	end
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(c77029000.drcon)
	e1:SetOperation(c77029000.drop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function c77029000.drckfil(c)
	return c:IsCode(77029000) and c:IsFaceup() 
end
function c77029000.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77029000.drckfil,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
end
function c77029000.drop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_CARD,0,77029000)
	Duel.Draw(tp,1,REASON_EFFECT) 
end
function c77029000.dckfil(c)
	return c.named_with_PNC 
end 
function c77029000.damval(e,re,val,r,rp,rc) 
	local lp=Duel.GetLP(tp)
	if Duel.GetFlagEffect(tp,07029000)==0 and val>=lp and Duel.IsExistingMatchingCard(c77029000.dckfil,tp,LOCATION_ONFIELD,0,1,nil) then 
	Duel.RegisterFlagEffect(tp,07029000,0,0,0) 
	Duel.SetLP(tp,2000) 
	local flag=Duel.GetFlagEffectLabel(tp,77029000) 
	if flag==nil then 
	Duel.RegisterFlagEffect(tp,77029000,0,0,0,2) 
	local te=Duel.IsPlayerAffectedByEffect(tp,77029000) 
	if te~=nil then 
	te:Reset() 
	end
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029000,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029000)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	else
	Duel.SetFlagEffectLabel(tp,77029000,flag+2) 
	local te=Duel.IsPlayerAffectedByEffect(tp,77029000) 
	if te~=nil then 
	te:Reset() 
	end
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029000,flag+2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029000)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	end
	return 0 
	end
	return val 
end
function c77029000.ckfil(c,tp) 
	return c:IsAbleToHand() and c.named_with_PNC and c:IsControler(tp) and not c:IsLocation(LOCATION_HAND)
end
function c77029000.rhcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local flag=Duel.GetFlagEffectLabel(tp,77029000) 
	if flag==nil then 
	Duel.RegisterFlagEffect(tp,77029000,0,0,0,1)
	local te=Duel.IsPlayerAffectedByEffect(tp,77029000) 
	if te~=nil then 
	te:Reset() 
	end
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029000,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029000)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	else
	Duel.SetFlagEffectLabel(tp,77029000,flag+1) 
	local te=Duel.IsPlayerAffectedByEffect(tp,77029000) 
	if te~=nil then 
	te:Reset() 
	end
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029000,flag+1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029000)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	end 
end
function c77029000.rhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c77029000.ckfil,1,nil,tp) end 
	local g=eg:Filter(c77029000.ckfil,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,0)
end
function c77029000.sumfilter(c)
	return c:IsSummonable(true,nil) and c.named_with_PNC 
end
function c77029000.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c77029000.ckfil,nil,tp) 
	if g:GetCount()>0 then 
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local flag=Duel.GetFlagEffectLabel(tp,77029000) 
	if flag==nil then return false end
	local x=Duel.Damage(tp,flag*500,REASON_EFFECT)  
	if x>=1500 and Duel.IsExistingMatchingCard(c77029000.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(77029000,0)) then
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local sg=Duel.SelectMatchingCard(tp,c77029000.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.Summon(tp,sg:GetFirst(),true,nil)
		end
	end  
	end 
end






