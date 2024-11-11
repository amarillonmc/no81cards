--机战广域空间
local m=49811262
local cm=_G["c"..m] 
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.activate1)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.rmcon)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
end
function cm.filter(c)
	return c:IsCode(904185,83054225) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x101b,TYPES_TOKEN_MONSTER,0,0,1,RACE_MACHINE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local flag=false
	if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x101b,TYPES_TOKEN_MONSTER,0,0,1,RACE_MACHINE,ATTRIBUTE_WIND) then
		if ft>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			flag=true
		end
		local token=Duel.CreateToken(tp,m+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		if flag==true then
			local token=Duel.CreateToken(tp,m+1)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		if flag==true then
			local token=Duel.CreateToken(tp,m+1)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard,0x101b)))
	e1:SetValue(cm.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	Duel.RegisterEffect(e4,tp)
end
function cm.sumlimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end