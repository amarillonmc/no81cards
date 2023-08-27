--被封印的双子·烈焰
local cm,m,o=GetID()
cm.name = "被封印的双子·烈焰"
function cm.initial_effect(c)
	aux.AddCodeList(c,60002336)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--fusion
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_COUNTER) 
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.ddtg)
	e1:SetOperation(cm.ddop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetFlagEffect(tp,m+1)~=0 and Duel.GetFlagEffect(tp,m+10000000)==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,m+10000000,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.fil(c)
	return c:IsCode(60002336) and c:IsFaceup()
end
function cm.filx(c)
	return c:IsCode(60002338) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.ddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(cm.filx,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)  end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE) 
end  
function cm.ddop(e,tp,eg,ep,ev,re,r,rp)  
   local c=e:GetHandler()
   local tc=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_MZONE,0,1,1,c,e,tp):GetFirst()
   if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.filx,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) then
		local uc=Duel.SelectMatchingCard(tp,cm.filx,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(uc,0,tp,tp,false,false,POS_FACEUP)
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,uc)
		Duel.Destroy(sg,REASON_EFFECT)
   end
end 




