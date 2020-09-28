--终极挑战-危机合约
function c79029310.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetOperation(c79029310.reop)
	c:RegisterEffect(e1)
	--sigle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e3)	  
end
function c79029310.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_RULE)
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
	Duel.Draw(tp,1,REASON_RULE)
	end   
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()~=tp then return end
	if not Duel.SelectEffectYesNo(tp,e:GetHandler()) then return end
	local ft=2
	local chk=true
	while chk do
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={0xdc0f,OPCODE_ISSETCARD}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	if ac==79029311 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	Duel.RegisterEffect(e1,tp)
	table.insert(getmetatable(e:GetHandler()).announce_filter,79029311)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_ISCODE)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_AND)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_NOT)
	ft=ft-1
	elseif ac==79029312 then
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_USE_EXTRA_MZONE)
	e2:SetValue(2)
	Duel.RegisterEffect(e2,tp)
	table.insert(getmetatable(e:GetHandler()).announce_filter,79029312)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_ISCODE)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_NOT)
	ft=ft-1
	else
	end
	if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(79029310,0)) then
	chk=false
	end
	end
end














