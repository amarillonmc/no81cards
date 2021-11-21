--G-神智机兵 炎
local m=16107103
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local nova=0x1cc ----nova counter
function cm.initial_effect(c)
	c:EnableCounterPermit(nova)
	local e0_1,e0_2,e_3=rk.indes(c,m)
	local e1_1,e1_2=rk.indes1(c,m,ATTRIBUTE_FIRE)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(cm.efcon)
	e2:SetOperation(cm.efop)
	c:RegisterEffect(e2)
end
function cm.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local reset_flag=RESET_EVENT+RESETS_STANDARD
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DESTROYED)
	--e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	rc:RegisterEffect(e1,true)
	rc:RegisterFlagEffect(0,reset_flag,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function cm.repfilter(c,tp)
	local a1=c:IsPreviousLocation(LOCATION_ONFIELD)
	local a2=c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE)
	local a3=not c:IsReason(REASON_REPLACE)
	local a4=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c)
	return a1 and a2 and a3 and a4
end
function cm.repfilter1(c,tp)
	g=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_DECK,0,nil,c)
	return g:GetCount()>0
end
function cm.thfilter(c,ec)
	return ( (c:IsType(TYPE_MONSTER) and ec:IsType(TYPE_MONSTER)) or (c:IsType(TYPE_SPELL) and ec:IsType(TYPE_SPELL)) or (c:IsType(TYPE_TRAP) and ec:IsType(TYPE_TRAP)) ) and c:IsAbleToHand() and c:IsSetCard(0xccc)
end
function cm.thfilter1(c,ec)
	if ( (c:IsType(TYPE_MONSTER) and ec:IsType(TYPE_MONSTER)) or (c:IsType(TYPE_SPELL) and ec:IsType(TYPE_SPELL)) or (c:IsType(TYPE_TRAP) and ec:IsType(TYPE_TRAP)) ) and c:IsAbleToHand() and c:IsSetCard(0xccc) then
		c:RegisterFlagEffect(m,0,0,0)
		return true
	else
		return false
	end
end
function cm.thfilter2(c)
	return c:GetFlagEffect(m)>0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=eg:Filter(cm.repfilter,nil,tp)
	if chk==0 then return sg:GetCount()>0 end
	sg:KeepAlive()
	e:SetLabelObject(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject():Filter(cm.repfilter1,nil,tp)
	local g=Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_DECK,0,nil)
	for tc in aux.Next(g) do
		tc:ResetFlagEffect(m)
	end
	local sg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg2=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_SPELL)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg3=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_TRAP)
	sg:Merge(sg1)
	sg:Merge(sg2)
	sg:Merge(sg3)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end