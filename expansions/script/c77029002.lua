--PNC 苏尔
function c77029002.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77029002,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,77029002)
	e1:SetTarget(c77029002.thtg)
	e1:SetOperation(c77029002.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--Destroy 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,77029002)
	e1:SetCondition(c77029002.decon)
	e1:SetCost(c77029002.decost)
	e1:SetTarget(c77029002.detg)
	e1:SetOperation(c77029002.deop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,17029002)
	e2:SetCost(c77029002.decost)
	e2:SetTarget(c77029002.detg)
	e2:SetOperation(c77029002.deop)
	c:RegisterEffect(e2)  
end
c77029002.named_with_PNC=true 
function c77029002.thfilter(c)
	return c.named_with_PNC and c:IsAbleToHand()
end
function c77029002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77029002.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	local tg=Duel.GetMatchingGroup(c77029002.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local lvt={}
	local tc=tg:GetFirst()
	while tc do
		local tlv=0
		tlv=tlv+tc:GetLevel()
		lvt[tlv]=tlv
		tc=tg:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77029002,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	e:SetLabel(lv)
	local flag=Duel.GetFlagEffectLabel(tp,77029002) 
	if flag==nil then 
	Duel.RegisterFlagEffect(tp,77029002,0,0,0,lv) 
	local te=Duel.IsPlayerAffectedByEffect(tp,77029002) 
	if te~=nil then 
	te:Reset() 
	end
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029002,lv))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029002)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	else
	Duel.SetFlagEffectLabel(tp,77029002,flag+lv) 
	local te=Duel.IsPlayerAffectedByEffect(tp,77029002) 
	if te~=nil then 
	te:Reset() 
	end
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029002,flag+lv))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029002)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c77029002.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	local g1=Duel.GetMatchingGroup(c77029002.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil) 
	local g=g1:Filter(Card.IsLevel,nil,lv)
	if g:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT) then 
	Duel.ConfirmCards(1-tp,sg) 
	Duel.BreakEffect()
	local flag=Duel.GetFlagEffectLabel(tp,77029002) 
	if flag==nil then return false end
	Duel.Damage(tp,flag*500,REASON_EFFECT)  
	end
	end
end
function c77029002.decon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c77029002.decost(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c77029002.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end 
function c77029002.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=Duel.GetFlagEffectLabel(tp,77029000) 
	if flag==nil then flag=0 end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil)
	if Duel.Destroy(dg,REASON_EFFECT) and flag>=1 and Duel.SelectYesNo(tp,aux.Stringid(77029002,1)) then 
	local te=Duel.IsPlayerAffectedByEffect(tp,77029000) 
	if te~=nil then 
	te:Reset() 
	end
	if flag-1>0 then 
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029000,flag-1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029000)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	end   
	local flag=Duel.GetFlagEffectLabel(tp,77029001) 
	if flag==nil then 
	Duel.RegisterFlagEffect(tp,77029001,0,0,0,1) 
	local te=Duel.IsPlayerAffectedByEffect(tp,77029001) 
	if te~=nil then 
	te:Reset() 
	end
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029001,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029001)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	else
	Duel.SetFlagEffectLabel(tp,77029001,flag+1) 
	local te=Duel.IsPlayerAffectedByEffect(tp,77029001) 
	if te~=nil then 
	te:Reset() 
	end
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029001,flag+1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029001)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	end 
	end
	end
end




