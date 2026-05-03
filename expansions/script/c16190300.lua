--三千无明
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,16170120)
	--赋予效果    
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--战伤双倍    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCondition(s.damcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	--盖放回合发动    
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(s.actcon)
	c:RegisterEffect(e3)
end    
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then    
    	local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(s.fuslimit)
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e6)
    	local fid=c:GetFieldID()
		tc:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e7:SetCode(EVENT_PHASE+PHASE_END)
		e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e7:SetCountLimit(1)
		e7:SetLabel(fid)
		e7:SetLabelObject(tc)
		e7:SetCondition(s.tgcon)
		e7:SetOperation(s.tgop)
		e7:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e7,tp)
    end
end    
function s.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(id+o)==e:GetLabel()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase()
end
function s.filter1(c)
	return c:IsCode(16170120) and c:IsFaceup()
end
function s.filter2(c)
	return c:GetFlagEffect(id+o)>0 and c:IsFaceup()
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(s.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,s.filter2,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc:IsRelateToEffect(e) then
    	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(s.regop)
		hc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(s.damcon0)
		e2:SetValue(DOUBLE_DAMAGE)
		hc:RegisterEffect(e2)
        if tc:IsRelateToEffect(e) then
        	local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetOperation(s.regop)
			tc:RegisterEffect(e3)
        	local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetCondition(s.damcon0)
			e4:SetValue(DOUBLE_DAMAGE)
			tc:RegisterEffect(e4)
        end
    end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.damcon0(e)
	return e:GetHandler():GetFlagEffect(id)==0
end
function s.actfilter(c)
	return c:IsFaceup() and c:IsCode(16170120)
end
function s.actcon(e)
	return Duel.IsExistingMatchingCard(s.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end