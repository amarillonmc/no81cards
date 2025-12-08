--垒路的基石 蕾欧娜
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	MTC.StrinovaPUS(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	
	MTC.StrinovaChangeZone(c,cm.czop)
end
function cm.fil(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetOriginalCodeRule()~=m
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)<=Duel.GetFlagEffect(tp,m+10000000) end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=false
	local b2=false
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_MZONE,0,1,nil) then b1=true end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	if chk==0 then return b1 or b2 end
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local b1=false
	local b2=false
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_MZONE,0,1,nil) then b1=true end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	if not b1 and not b2 then return end
	local op=aux.SelectFromOptions(tp,
				{b1,aux.Stringid(m,4)},
				{b2,aux.Stringid(m,5)})
	local pzone1=LOCATION_MZONE
	local pzone2=LOCATION_SZONE
	if op==2 then 
		pzone1=LOCATION_SZONE
		pzone2=LOCATION_MZONE
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,cm.fil,tp,pzone1,0,1,1,nil):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,pzone2,POS_FACEUP,true) end
end

function cm.czop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.RegisterFlagEffect(tp,m+10000000,RESET_PHASE+PHASE_END,0,1)
end