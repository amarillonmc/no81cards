--虚无之结界像
local cm,m=GetID()
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetTarget(function(e,c)
					return c:IsAttack(1000) and c:IsDefense(1000)
				end)
	c:RegisterEffect(e2)
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(function(e)
						local ac,bc=Duel.GetBattleMonster(e:GetHandlerPlayer())
						return (ac and ac:IsAttack(1000) and ac:IsDefense(1000)) or (bc and bc:IsAttack(1000) and bc:IsDefense(1000))
					end)
	c:RegisterEffect(e2)--]]
	--remove
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,2))
	e0:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCondition(cm.recon)
	e0:SetOperation(cm.reop)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--replace
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e5:SetCountLimit(1,11451896+EFFECT_COUNT_CODE_DUEL)
	e5:SetRange(LOCATION_HAND+LOCATION_DECK)
	e5:SetOperation(cm.rep)
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		local _SpecialSummon=Duel.SpecialSummon
		Duel.SpecialSummon=function(g,typ,sp,...)
			local sc=g
			if aux.GetValueType(g)=="Group" then
				if #g>1 then return _SpecialSummon(g,typ,sp,...) end
				sc=g:GetFirst()
			end
			if sc:GetOriginalCode()~=m or not (Duel.CheckLocation(sp,LOCATION_PZONE,0) or Duel.CheckLocation(sp,LOCATION_PZONE,1)) or not Duel.SelectEffectYesNo(sp,sc,aux.Stringid(m,0)) then return _SpecialSummon(g,typ,sp,...) end
			Duel.MoveToField(sc,sp,sp,LOCATION_PZONE,POS_FACEUP,true)
			return false
		end
	end
end
function cm.rep(e,tp,eg,ep,ev,re,r,rp)
	local table={19740112,10963799,47961808,73356503,46145256,84478195}
	for i,code in ipairs(table) do
		local cn=_G["c"..code]
		if type(cn)=="table" and type(cn.sumlimit)=="function" then
			cn.sumlimit=function(e,c,sump,sumtype,sumpos,targetp)
							return not c:IsAttribute(1<<(i-1))
						end
		end
		local g=Duel.GetMatchingGroup(aux.FilterEqualFunction(Card.GetOriginalCode,code),0,0xff,0xff,nil)
		for tc in aux.Next(g) do tc:ReplaceEffect(code,0) end
	end
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	local tp=Duel.GetTurnPlayer()
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.CheckReleaseGroupEx(tp,cm.filter,1,REASON_COST,true,nil) and Duel.GetFlagEffect(tp,m)==0
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=Duel.GetTurnPlayer()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,cm.filter,1,1,REASON_COST,true,nil)
	local seq=g:GetFirst():IsOnField() and aux.GetColumn(g:GetFirst()) or 100
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+m,e,seq,0,0,g:GetFirst():GetAttribute())
	Duel.Release(g,REASON_COST)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.cclfilter(c,seq,attr)
	local seq1=aux.GetColumn(c)
	return c:IsFaceup() and (seq1==seq or (c:IsType(TYPE_MONSTER) and c:IsAttribute(attr)))
end
function cm.thfilter(c)
	return c:IsAttack(1000) and c:IsDefense(1000) and c:IsAbleToHand()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.cclfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,r,ev)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local g=Duel.GetMatchingGroup(cm.cclfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,r,ev)
		if #g>0 then
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end