--罗塔花园广场
Rotta=Rotta or {}
Rotta.loaded_metatable_list={}

local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(Rotta.ReMake)
	c:RegisterEffect(e2)
end
if not Rotta_Set then
	Rotta_Set=1
	Rotta_Hand={}
	Rotta_MZone={}
	Rotta_Grave={}
	Rotta_Removed={}
end
function Rotta.ReSign(c)
	Rotta_Hand={}
	Rotta_MZone={}
	Rotta_Grave={}
	Rotta_Removed={}
	
	local g=Duel.GetMatchingGroup(cm.Rottafil,c:GetControler(),LOCATION_HAND,0,nil)
	for tc in aux.Next(g) do
		table.insert(Rotta_Hand,tc)
	end
	g=Duel.GetMatchingGroup(cm.Rottafil,c:GetControler(),LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		table.insert(Rotta_MZone,tc)
	end
	g=Duel.GetMatchingGroup(cm.Rottafil,c:GetControler(),LOCATION_GRAVE,0,nil)
	for tc in aux.Next(g) do
		table.insert(Rotta_Grave,tc)
	end
	g=Duel.GetMatchingGroup(cm.Rottafil,c:GetControler(),LOCATION_REMOVED,0,nil)
	for tc in aux.Next(g) do
		table.insert(Rotta_Removed,tc)
	end
end
function Rotta.ReMake(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local num=0
	for i=1,60 do
		if Rotta_Hand[i] then g:AddCard(Rotta_Hand[i]) end
	end
	for tc in aux.Next(g) do
		if not tc:IsLocation(LOCATION_HAND) and tc:IsAbleToHand() then 
			if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then num=num+1 end
		end
	end
	g=Group.CreateGroup()
	for i=1,60 do
		if Rotta_MZone[i] then g:AddCard(Rotta_MZone[i]) end
	end
	for tc in aux.Next(g) do
		if not tc:IsLocation(LOCATION_MZONE) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then 
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then num=num+1 end
		end
	end
	g=Group.CreateGroup()
	for i=1,60 do
		if Rotta_Grave[i] then g:AddCard(Rotta_Grave[i]) end
	end
	for tc in aux.Next(g) do
		if not tc:IsLocation(LOCATION_GRAVE) and tc:IsAbleToGrave() then 
			if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then num=num+1 end
		end
	end
	g=Group.CreateGroup()
	for i=1,60 do
		if Rotta_Removed[i] then g:AddCard(Rotta_Removed[i]) end
	end
	for tc in aux.Next(g) do
		if not tc:IsLocation(LOCATION_REMOVED) and tc:IsAbleToRemove() then 
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then num=num+1 end
		end
	end
	if num~=0 then
		local rg=Duel.GetDecktopGroup(tp,num)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
	Rotta_Hand={}
	Rotta_MZone={}
	Rotta_Grave={}
	Rotta_Removed={}
end 
function cm.Rottafil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3624)
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3624)
		and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local pg=Duel.GetMatchingGroup(cm.pfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local cg=Duel.GetMatchingGroup(cm.Rottafil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if #pg~=0 and Duel.IsExistingMatchingCard(cm.Rottafil,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.ConfirmCards(1-tp,pg)
		if #cg==0 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
				Duel.ConfirmCards(1-tp,sg)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetTargetRange(1,0)
				e1:SetTarget(cm.splimit)
				e1:SetReset(RESET_PHASE+PHASE_END)
				--Duel.RegisterEffect(e1,tp)
			end
		elseif #cg>=1 then
			Rotta.ReSign(c)
		end
	end
end
function cm.pfil(c)
	return c:IsFacedown() or not c:IsPublic()
end
function cm.splimit(e,c)
	return not c:IsType(TYPE_FLIP)
end
function Rotta.handeff(c,tg,op)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(Rotta.fcon)
	e1:SetOperation(Rotta.heop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(Rotta.fcon2)
	e2:SetTarget(tg)
	e2:SetOperation(op)
	c:RegisterEffect(e2)
end
function Rotta.fcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	local tf=false
	local facedown=c:GetFlagEffect(code)
	local faceup=c:GetFlagEffect(code+10000000)
	if faceup+facedown==0 then
		if c:IsPublic() then c:RegisterFlagEffect(code+10000000,RESET_EVENT+RESETS_STANDARD,0,1)
		else c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,0,1) end
	elseif facedown==1 then
		if c:IsPublic() then
			c:ResetFlagEffect(code)
			c:RegisterFlagEffect(code+10000000,RESET_EVENT+RESETS_STANDARD,0,1)
			tf=true
			c:RegisterFlagEffect(code+20000000,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	elseif faceup==1 then
		if not c:IsPublic() then
			c:ResetFlagEffect(code+10000000)
			c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
	--Debug.Message(tf)
	return tf
end
function Rotta.fcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	local tf=false
	if c:GetFlagEffect(code+20000000)~=0 then
		c:ResetFlagEffect(code+20000000)
		tf=true
	end
	return tf
end
function Rotta.graveeff(c,code)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,code)
	e1:SetTarget(Rotta.gtg)
	e1:SetOperation(Rotta.gop)
	c:RegisterEffect(e1)
end

function Rotta.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return #Duel.GetDecktopGroup(tp,1)~=0 and c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function Rotta.gop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetDecktopGroup(tp,1)
	if Duel.SendtoGrave(dg,REASON_EFFECT)~=0 then 
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function Rotta.heop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RaiseEvent(c,EVENT_CUSTOM+m,nil,0,c:GetOwner(),c:GetOwner(),0)
end









