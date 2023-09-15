--桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀桀
Aria=Aria or {}
function Aria.ytdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_CHAIN,0,1)
	Duel.RegisterFlagEffect(tp,60002355,RESET_CHAIN,0,1)
end
function Aria.bkcon(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	return Duel.GetFlagEffect(tp,70002355)~=0
end
function Aria.bktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,70002355)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function Aria.bkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
function Aria.StartAria(c)
	local tp=c:GetControler()
	if Duel.GetFlagEffect(tp,60002353)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and not Duel.IsExistingMatchingCard(Aria.fil1,tp,LOCATION_GRAVE,0,1,nil,e,tp) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,Aria.fil1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if Duel.GetFlagEffect(tp,60002354)~=0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetOperation(Aria.op1)
		Duel.RegisterEffect(e2,tp)
	end
	if Duel.GetFlagEffect(tp,60002356)~=0 then
		--can't spsummon
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,1)
		e3:SetTarget(Aria.limit1)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
	if Duel.GetFlagEffect(tp,60002357)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if Duel.GetFlagEffect(tp,60002358)~=0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	if Duel.GetFlagEffect(tp,60002359)~=0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CHANGE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetValue(Aria.val1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e4:SetTargetRange(1,0)
		e4:SetValue(Aria.val1)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
	if Duel.GetFlagEffect(tp,60002360)~=0 then
		if Duel.IsExistingMatchingCard(Aria.fil2,tp,LOCATION_DECK,0,1,nil,e,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,Aria.fil2,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
	if Duel.GetFlagEffect(tp,60002361)~=0 then
		if Duel.IsExistingMatchingCard(Aria.fil2,tp,LOCATION_DECK,0,1,nil,e,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,Aria.fil2,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
	if Duel.GetFlagEffect(tp,60002362)~=0 then
		if Duel.IsExistingMatchingCard(Aria.fil2,tp,LOCATION_DECK,0,1,nil,e,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,Aria.fil2,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function Aria.fil1(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function Aria.fil2(c)
	return c:IsSetCard(0x627) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function Aria.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(60002355,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(g:GetFirst(),REASON_EFFECT)
	end
end
function Aria.limit1(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(TYPE_GEMINI) or c:IsType(TYPE_DUAL)
end
function Aria.val1(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
function Aria.scon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function Aria.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function Aria.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_MONSTER+TYPE_LINK)
	c:RegisterEffect(e1)
	local b1=false
	local b2=false
	local b3=false
	local b4=false
	local b5=false
	local b6=false
	local b7=false
	local b8=false
	if not c:IsLinkMarker(0x001) then b1=true end
	if not c:IsLinkMarker(0x002) then b2=true end
	if not c:IsLinkMarker(0x004) then b3=true end
	if not c:IsLinkMarker(0x008) then b4=true end
	if not c:IsLinkMarker(0x020) then b5=true end
	if not c:IsLinkMarker(0x040) then b6=true end
	if not c:IsLinkMarker(0x080) then b7=true end
	if not c:IsLinkMarker(0x100) then b8=true end
	local op=aux.SelectFromOptions(tp,
	{b1,aux.Stringid(60002355,1)},
	{b2,aux.Stringid(60002355,2)},
	{b3,aux.Stringid(60002355,3)},
	{b4,aux.Stringid(60002355,4)},
	{b5,aux.Stringid(60002355,5)},
	{b6,aux.Stringid(60002355,6)},
	{b7,aux.Stringid(60002355,7)},
	{b8,aux.Stringid(60002355,8)})
	if op==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0x001)
		c:RegisterEffect(e1)
	elseif op==2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0x002)
		c:RegisterEffect(e1)
	elseif op==3 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0x004)
		c:RegisterEffect(e1)
	elseif op==4 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0x008)
		c:RegisterEffect(e1)
	elseif op==5 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0x020)
		c:RegisterEffect(e1)
	elseif op==6 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0x040)
		c:RegisterEffect(e1)
	elseif op==7 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0x080)
		c:RegisterEffect(e1)
	elseif op==8 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0x100)
		c:RegisterEffect(e1)
	end
	if Duel.GetFlagEffect(tp,60002355)>=2 then
		Aria.StartAria(c)
	end
end
function Aria.scon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=1
end
function Aria.BackAria(c)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_TRAP+TYPE_LINK+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end












