--智慧猩
local m=13000751
local cm=_G["c"..m]
function c13000751.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,m+1000)
	e4:SetCondition(cm.con)
	e4:SetCost(cm.cost1)
	e4:SetTarget(cm.settg)
	e4:SetOperation(cm.setop)
	c:RegisterEffect(e4)
end
function cm.filter(c)
	return c:IsType(TYPE_RITUAL) 
end
function cm.filter1(c)
	return c:IsType(TYPE_RITUAL) and not c:IsPublic()
end
function cm.filter6(c)
	return not c:IsType(TYPE_LINK) and not c:IsType(TYPE_XYZ)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND,0,1,c) and Duel.IsExistingMatchingCard(cm.filter6,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(id)~=0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local dmg=Duel.GetMatchingGroup(Card.IsAbleToRemove,1-tp,0x04,0,nil)
    if #dmg>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,4)) then
        Duel.Hint(3,1-tp,503)
        local tc=dmg:Select(1-tp,1,1,nil):GetFirst()
        if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 and tc:IsLocation(0x20) then
            tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_PHASE+PHASE_END)
            e1:SetLabelObject(tc) 
            e1:SetCountLimit(1)
            e1:SetCondition(cm.retcon)
            e1:SetOperation(cm.retop)
            e1:SetReset(RESET_PHASE+PHASE_END) 
            Duel.RegisterEffect(e1,tp)
        end
    end
    if not Duel.IsExistingMatchingCard(cm.filter6,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sel=nil
	local g1=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_HAND,0,1,99,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local bb=Duel.SelectMatchingCard(tp,cm.filter6,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	local ct=#g1
	local dd=0
	if bb:IsLevel(1) then
		sel=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	if sel==1 then
		ct=ct*-1
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(ct)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	bb:RegisterEffect(e1)
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g3=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local i=g2:GetFirst()
	local lev=0
	sel=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
	if sel==0 then
	while i do
	if i:IsType(TYPE_LINK) then
	dd=Card.GetLink(i)  
	elseif i:IsType(TYPE_XYZ) then
	dd=Card.GetRank(i)
	else
	dd=Card.GetLevel(i)
	end
	lev=lev+dd
	i=g2:GetNext()
end
end
if sel==1 then
lev=1
while i do
	if i:IsType(TYPE_LINK) then
	 dd=Card.GetLink(i)   
	elseif i:IsType(TYPE_XYZ) then
	 dd=Card.GetRank(i)
	else
	dd=Card.GetLevel(i)
	end
	lev=lev*dd
	i=g2:GetNext()
end
end
if lev%24==0 then
Duel.Destroy(g3,REASON_EFFECT)
end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)  
	e:SetLabel(Duel.AnnounceLevel(tp,1,12))  
end 
function cm.op(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local num=e:GetLabel()
Duel.ConfirmDecktop(tp,num)
local g=Duel.GetDecktopGroup(tp,num)
local aa=g:Filter(cm.filter,nil)
local bb=#g-#aa
	if #g>0 and Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.DisableShuffleCheck()
		Duel.Damage(tp,bb*1000,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sc=g:FilterSelect(tp,cm.filter,1,1,nil):GetFirst()
		if sc and sc:IsAbleToHand() then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
			Duel.ShuffleHand(tp)
		else
			Duel.SendtoGrave(sc,REASON_RULE)
		end
	end
	if #g>1 then
		Duel.SortDecktop(tp,tp,#g-1)
		for i=1,#g-1 do
			local dg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end