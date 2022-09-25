--辉煌之裁龙
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(cm.con3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(cm.con3)
	e4:SetValue(cm.val4)
	c:RegisterEffect(e4)
end
--e2
function cm.con2(e,tp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and e:GetHandler():IsSummonable(true,nil,1)
end
function cm.opf2(g,rc,minc,maxc)
	return Duel.CheckTribute(rc,minc,maxc,g) and (g:GetCount()==minc or g:GetCount()==maxc)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTributeGroup(c)
	local min,max=c:GetTributeRequirement()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	g=g:SelectSubGroup(tp,cm.opf2,true,1,#g,c,min,max)
	if not g then return end
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetLabelObject(g)
	e1:SetCondition(function()return true end)
	e1:SetOperation(function (ce,ctp,ceg,cep,cev,cre,cr,crp,cc)
						cc:SetMaterial(g)
						Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
						e1:Reset()
					end)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	Duel.Summon(tp,c,true,e1,0)
end
--e3
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local c=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		if not c then return end
		Duel.Hint(HINT_CARD,tp,e:GetHandler():GetCode())
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
--e4
function cm.valf4(c,seq)
	return c:IsFaceup() and c:GetType()==0x20002 and aux.SZoneSequence(c:GetSequence())==4-seq
end
function cm.val4(e,te)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() or te:GetActivateLocation()|LOCATION_ONFIELD==0 then return false end
	return Duel.IsExistingMatchingCard(cm.valf4,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil,te:GetActivateSequence())
end