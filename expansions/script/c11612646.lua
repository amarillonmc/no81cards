--龙仪巧-武仙流星＝HER
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
local m=11612646
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/11610000") end) then require("script/11610000") end
cm.text=zhc_lhq_wx
function c11612646.initial_effect(c)
	c:EnableReviveLimit()
	local e00=fpjdiy.Zhc(c,cm.text)
	 --
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(11612646,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c11612646.valcheck)
	c:RegisterEffect(e0)
 --draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e4:SetTarget(c11612646.filter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetTarget(c11612646.filter)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(11612646,1))
	e6:SetCategory(CATEGORY_DECKDES)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetRange(LOCATION_MZONE)
	--e6:SetCountLimit(1,11612648)
	e6:SetTarget(c11612646.detg)
	e6:SetOperation(c11612646.deop)
	c:RegisterEffect(e6)
  --Battle!!
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2,11612646)
	e1:SetCondition(c11612646.bacon)
	e1:SetTarget(c11612646.batg)
	e1:SetOperation(c11612646.baop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c11612646.matcon)
	e3:SetOperation(c11612646.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11612646,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11612647)
	e2:SetCondition(c11612646.descon)
	e2:SetOperation(c11612646.desop)
	c:RegisterEffect(e2)
--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(cm.tccon)
	e7:SetOperation(cm.tcop)
	c:RegisterEffect(e7)
end
function cm.tccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_MZONE) and c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp) then		return true
	else
		return false
	end
end
function cm.tcop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(zhc_lhq_wx_2)
end
--
function c11612646.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function c11612646.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(c11612646.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c11612646.filter(e,c)
	return Duel.GetAttackTarget()~=nil
end
--
function c11612646.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetBattledGroup()
	local tc=g:GetFirst()
	local p=tc:GetControler()
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,4) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,4)
end
function c11612646.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.DiscardDeck(1-tp,4,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	for oc in aux.Next(og) do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		oc:RegisterEffect(e3)
	end
end
function c11612646.damval(e,re,val,r,rp,rc)
	local val=Duel.GetBattleDamage(1)
	if val>=1000 then
		return 0	
	end
	return val
end

function c11612646.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c11612646.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(11612646,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11612646,0))
end
function c11612646.bacon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local ct=1
	if Duel.GetFlagEffect(tp,11612647)>0 then
		ct=2
	end
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and e:GetHandler():GetFlagEffect(11612646)>0 and Duel.GetFlagEffect(tp,11612646)<ct  
end
function c11612646.batg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return c:IsAttackable()
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.RegisterFlagEffect(tp,11612646,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c11612646.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackable() and c:IsControler(tp) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tc=g:GetFirst()
		if tc:IsControler(1-tp) and tc:IsRelateToEffect(e) then
			Duel.CalculateDamage(c,tc)
		end
	end
end
function c11612646.desfilter(c,p,s)
	local seq=c:GetSequence()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x154) and c:GetReasonPlayer()==1-p and c:IsPreviousControler(p) and s<5 and math.abs(seq-s)<=1
end
function c11612646.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=e:GetHandler():GetControler()
	return e:GetHandler():IsAttackPos() and eg:IsExists(c11612646.desfilter,1,nil,p,c:GetSequence())
end
function c11612646.desop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()  
	 Duel.Hint(HINT_CARD,0,11612646)
	 local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c):RandomSelect(tp,1)
	 local tc=g:GetFirst()
	 if c:IsAttackable() and #g>0 then 
		Duel.CalculateDamage(c,tc)
		if tc:IsControler(tp) then
			Duel.RegisterFlagEffect(tp,11612647,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
	 end
end
