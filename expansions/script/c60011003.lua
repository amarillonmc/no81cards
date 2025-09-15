--神圣圆桌领域 卡美洛
camelot=camelot or {}
camelot.loaded_metatable_list={}

local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(60011003)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60011003,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.activate)
	c:RegisterEffect(e3)
end
camelot.Check={}
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	if eg:IsExists(cm.sfil,1,nil,tp) then
		Duel.RegisterFlagEffect(tp,m+10000000,RESET_PHASE+PHASE_END,0,1)
		local num1=Duel.GetFlagEffect(tp,m+10000000)
		local num2=Duel.GetFlagEffect(tp,m+20000000)
		if num1-num2>=1 then
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,nil,0,tp,tp,0)
		end
	end
end
function cm.sfil(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x107a) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
if not cm.change then
	cm.change=true
	cm.register_effect=Card.RegisterEffect
	Card.RegisterEffect=function (car,eff,...)
		cm.register_effect(car,eff,...)
		if eff:IsHasType(EFFECT_TYPE_IGNITION) and eff:IsHasRange(LOCATION_HAND) then
			local neff=eff:Clone()
			neff:SetDescription(aux.Stringid(60011003,1))
			neff:SetType(eff:GetType()-EFFECT_TYPE_IGNITION+EFFECT_TYPE_QUICK_O)
			neff:SetCode(EVENT_FREE_CHAIN)
			neff:SetRange(LOCATION_HAND)
			if eff:GetCondition()~=nil then
				neff:SetCondition(cm.ncon)
			else
				neff:SetCondition(cm.ncon2)
			end
			if eff:GetOperation()~=nil then
				neff:SetOperation(cm.nop)
			else
				neff:SetOperation(cm.nop2)
			end
			cm.register_effect(car,neff,...)
			cm[neff]=eff
		end
	end
end

function cm.ncon(e,tp,eg,ep,ev,re,r,rp)
	local oc=cm[e]:GetCondition()
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local num=Duel.GetMatchingGroup(cm.confil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil):GetClassCount(Card.IsCode)
	return oc(e,tp,eg,ep,ev,re,r,rp) and Duel.GetFlagEffect(tp,60011003)<num and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x107a) and Duel.IsPlayerAffectedByEffect(tp,60011003)
end
function cm.ncon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local num=Duel.GetMatchingGroup(cm.confil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil):GetClassCount(Card.IsCode)
	return Duel.GetFlagEffect(tp,60011003)<num and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x107a) and Duel.IsPlayerAffectedByEffect(tp,60011003)
end
function cm.confil(c)
	return ((c:IsPublic() and c:IsLocation(LOCATION_HAND)) or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x207a)
end
function cm.nop(e,tp,eg,ep,ev,re,r,rp,c)
	local oc=cm[e]:GetOperation()
	oc(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,60011003,RESET_PHASE+PHASE_END,0,1)
end
function cm.nop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RegisterFlagEffect(tp,60011003,RESET_PHASE+PHASE_END,0,1)
end
function cm.filter(c)
	return c:IsSetCard(0x207a) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.DisableShuffleCheck()
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		Duel.ResetFlagEffect(tp,m+10000000)
		Duel.RegisterFlagEffect(tp,m+20000000,RESET_PHASE+PHASE_END,0,1)
	end
end

function camelot.start1(c,code)
	aux.AddCodeList(c,code)
	--space check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetLabel(code)
	e0:SetRange(0x1ff)
	e0:SetOperation(camelot.checkop)
	c:RegisterEffect(e0)
end
function camelot.start2(c,code)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetLabel(code)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(camelot.spop)
	c:RegisterEffect(e1)
end
function camelot.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if Duel.GetTurnCount()~=1 then return end
	if not camelot.Check[c:GetOriginalCode()] then
		camelot.Check[c:GetOriginalCode()]=1
		local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x1ff,0,nil,c:GetOriginalCode())
		if #g==2 then
			local tc=g:RandomSelect(tp,1):GetFirst()
			tc:SetEntityCode(code,true)
			tc:ReplaceEffect(code,0,0)
		end
	end
end
function camelot.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPublic() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		
		Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EVENT_ADJUST)
		e1:SetLabel(e:GetLabel())
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(camelot.pubop)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1)
		
		Duel.SpecialSummonComplete()
		
		Duel.Readjust()
	end
end
function camelot.pubop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(camelot.checkpubfil,tp,LOCATION_HAND,0,nil,c:GetOriginalCode())
	if #g==0 then
		Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,camelot.pubfil,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		if tc then
			tc:RegisterFlagEffect(c:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(c:GetOriginalCode(),0))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		else
			if Duel.SendtoDeck(c,nil,1,REASON_EFFECT)==0 then return end
			if Duel.IsExistingMatchingCard(camelot.bldfil,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) and Duel.SelectYesNo(tp,aux.Stringid(c:GetOriginalCode(),0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,camelot.bldfil,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
				if g:GetCount()>0 then
					Duel.DisableShuffleCheck()
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end

		Duel.Readjust()
	end
end
function camelot.checkpubfil(c,code)
	return c:GetFlagEffect(code)~=0 and c:IsPublic()
end
function camelot.pubfil(c)
	return c:IsSetCard(0x207a) and not c:IsPublic()
end
function camelot.bldfil(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end

function camelot.bladestart(c,code)
	aux.EnableChangeCode(c,code,0x1ff)
	c:SetUniqueOnField(1,0,code)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(camelot.eqtg)
	e1:SetOperation(camelot.eqop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(camelot.eqlimit)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_HAND)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(camelot.atktg)
	e3:SetValue(500)
	c:RegisterEffect(e3)
end
function camelot.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function camelot.eqfil(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function camelot.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and camelot.eqfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(camelot.eqfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,camelot.eqfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function camelot.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
function camelot.atktg(e,c)
	return c:IsSetCard(0x107a) and c:IsFaceup() and e:GetHandler():IsPublic()
end