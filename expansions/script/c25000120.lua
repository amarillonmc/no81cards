--布莱克指令
--why you creat this card, effects that send to deck without confirm is very common ??? very hape.
if not pcall(function() require("expansions/script/c25000119") end) then require("script/c25000119") end
local m,cm=rscf.DefineCard(25000120)
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=rsef.ACT(c)
	local e2=rsef.QO(c,nil,{m,0},1,"sp",nil,LOCATION_SZONE,nil,nil,rsop.target({cm.spfilter,"sp",LOCATION_HAND },{cm.cfilter,nil,0,LOCATION_MZONE }),cm.spop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCondition(cm.drcon1)
	e3:SetOperation(cm.drop1)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
	--sp_summon effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCondition(cm.regcon)
	e4:SetOperation(cm.regop)
	e4:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetCondition(cm.drcon2)
	e5:SetOperation(cm.drop2)
	e5:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e5)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and rsufo.IsSetM(c)
end
function cm.cfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_MZONE,nil)
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if #g<=0 or #sg<=0 then return end
	rshint.Select(tp,HINTMSG_OPPO)
	local tg=g:Select(tp,1,1,nil)
	Duel.HintSelection(tg)
	local tc=tg:GetFirst()
	rshint.Select(tp,"sp")
	local sc=sg:Select(tp,1,1,nil):GetFirst()
	if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_ATTACK)>0 then
		Duel.CalculateDamage(sc,tc)
		if sc:IsAbleToHand() and not sc:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
		end
	end
end
function cm.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsLocation(LOCATION_DECK) and c:GetPreviousControler()==tp
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,m)
	Duel.ResetFlagEffect(tp,m)
	Duel.Draw(tp,n,REASON_EFFECT)
end

