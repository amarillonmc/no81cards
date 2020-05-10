--魔王-暴虐公
function c33400351.initial_effect(c)
	  c:SetUniqueOnField(1,0,33400351)  
c33400351.dfc_front_side=33400350
c33400351.dfc_back_side=33400351
	--ATK UP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400351,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1,33400351)
	e2:SetTarget(c33400351.attg)
	e2:SetOperation(c33400351.atop)
	c:RegisterEffect(e2)
	 --Remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400351,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
	e3:SetCountLimit(1,33400351)
	e3:SetTarget(c33400351.retg)
	e3:SetOperation(c33400351.reop)
	c:RegisterEffect(e3)
	--change code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_SZONE) 
	e0:SetCondition(c33400351.changecon)
	e0:SetOperation(
		 function(e,tp,eg,ep,ev,re,r,rp) 
		 Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+33400351,e,0,0,0,0) 
		 end)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_SZONE) 
	e4:SetCode(EVENT_CUSTOM+33400351)
	e4:SetTarget(c33400351.changetg)
	e4:SetOperation(c33400351.changeop)
	c:RegisterEffect(e4)
	 --back
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e9:SetCondition(c33400351.backon)
	e9:SetOperation(c33400351.backop)
	c:RegisterEffect(e9)
end
function c33400351.seqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341)
end
function c33400351.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400351.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c33400351.seqfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c33400351.atop(e,tp,eg,ep,ev,re,r,rp)   
local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not Duel.IsExistingMatchingCard(c33400351.seqfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400351,1))
	local tg=Duel.SelectMatchingCard(tp,c33400351.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=tg:GetFirst()
	  local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetDescription(aux.Stringid(33400351,3))
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		tc:RegisterEffect(e2)
end

function c33400351.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c33400351.chfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c33400351.chfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c33400351.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then				 
			local e5=Effect.CreateEffect(c)
			e5:SetDescription(aux.Stringid(33400351,5))
			e5:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
			e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e5:SetCode(EVENT_BATTLE_DESTROYING)
			e5:SetCondition(aux.bdcon)
			e5:SetCost(c33400351.cost)
			e5:SetOperation(c33400351.tgop)
			e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e5)   
		 tc:RegisterFlagEffect(33400351,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(33400351,4))  
	end
end
function c33400351.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c33400351.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_SZONE,nil)
	if not g1 and not g2 then return end 
	local ck1=g1:Filter(Card.IsAbleToRemove,nil)
	local ck2=g2:Filter(Card.IsAbleToRemove,nil)
	local n=7
	local m=7
	if g1 and ck1 and g2 and ck2 then 
		n=Duel.SelectOption(tp,aux.Stringid(33400351,6),aux.Stringid(33400351,7),aux.Stringid(33400351,8),aux.Stringid(33400351,9))
		m=n
	elseif g1 and ck1 and g2 and not ck2 then
		n=Duel.SelectOption(tp,aux.Stringid(33400351,6),aux.Stringid(33400351,7),aux.Stringid(33400351,9))
		if n==2 then m=3
		else m=n
		end
	elseif g1 and ck1 and not g2  then
		n=Duel.SelectOption(tp,aux.Stringid(33400351,6),aux.Stringid(33400351,7))
		m=n
   elseif g1 and not ck1 and g2 and not ck2 then
		n=Duel.SelectOption(tp,aux.Stringid(33400351,6),aux.Stringid(33400351,8),aux.Stringid(33400351,9))
		if n==0 then m=n
		else m=n+1
		end
	elseif not g1  and g2 and not ck2 then
		n=Duel.SelectOption(tp,aux.Stringid(33400351,8),aux.Stringid(33400351,9))
		m=n+2
	end 
	if m==0 then Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT) end
	if m==1 then Duel.SendtoGrave(g1,REASON_EFFECT) end
	if m==2 then Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT) end
	if m==3 then Duel.SendtoGrave(g2,REASON_EFFECT) end
end

function c33400351.chfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3343) and c:IsType(TYPE_MONSTER)
end
function c33400351.changecon(e,tp,eg,ep,ev,re,r,rp)
   return not Duel.IsExistingMatchingCard(c33400351.chfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c33400351.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	c:RegisterFlagEffect(33400351,RESET_CHAIN,0,1) 
	if chk==0 then return 33400351 and 33400351==c:GetOriginalCode() and c:GetFlagEffect(33400360)<2 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c33400351.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	c:SetEntityCode(33400350,true)
	c:ReplaceEffect(33400350,0,0)
end

function c33400351.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function c33400351.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.dfc_front_side
	c:SetEntityCode(tcode)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
end