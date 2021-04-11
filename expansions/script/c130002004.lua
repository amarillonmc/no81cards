--伴月之龙战士
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(130002004)
function cm.initial_effect(c)
	local e1=rscf.SetSummonCondition(c,true,aux.FALSE)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(cm.ttcon)
	e2:SetOperation(cm.ttop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(cm.ttcon2)
	e3:SetOperation(cm.ttop2)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)


	--local e11=rsef.RegisterClone(c,e2,"code",EFFECT_SET_PROC)
	local e12=rsef.RegisterClone(c,e3,"code",EFFECT_SET_PROC)

	local e4=rsef.FTO(c,EVENT_SUMMON)
	e4:SetRange(LOCATION_HAND)
	rsef.RegisterSolve(e4,cm.negcon,nil,nil,cm.negop)


	
	local e5=rsef.FC(c,EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(cm.thop)

end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_ADVANCE) then return end
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	if #g<=0 then return end
	local ct=Duel.SendtoHand(g,nil,REASON_EFFECT)
	local bct=c:GetFlagEffectLabel(m)
	if not bct then return end
	e:SetLabel(ct)
	if e:GetLabel()==bct then
		local hg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
		if #hg>0 then
			Duel.SendtoDeck(hg,nil,2,REASON_EFFECT)
		end
	end
	Duel.Readjust()
end
function cm.ttcon(e,c,minc)
	if c==nil then return true end
	return c:IsLevelAbove(5) and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function cm.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	rshint.Select(tp,"tg")
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,0,LOCATION_MZONE,1,99,nil)
	c:SetMaterial(tg)
	Duel.SendtoGrave(tg,REASON_SUMMON+REASON_COST+REASON_MATERIAL)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	c:RegisterFlagEffect(m,rsreset.est-RESET_TOFIELD,0,1,ct)
end
function cm.ttcon2(e,c,minc)
	if c==nil then return true end
	return c:IsLevelAbove(5) and cm.switch --and cm.switch:FilterCount(Card.IsHasEffect,nil,EFFECT_CANNOT_DISABLE_SUMMON)~=#cm.switch
end
function cm.ttop2(e,tp,eg,ep,ev,re,r,rp,c)  
	c:SetMaterial(Group.CreateGroup())
	Duel.NegateSummon(cm.switch)
	Duel.SendtoGrave(cm.switch,REASON_COST+REASON_SUMMON)
	cm.switch=false
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	c:RegisterFlagEffect(m,rsreset.est-RESET_TOFIELD,0,1,ct)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	cm.switch=eg
	local res=tp~=ep and Duel.GetCurrentChain()==0 and (e:GetHandler():IsSummonable(true,nil,1) or  e:GetHandler():IsMSetable(true,nil,1))
	cm.switch=false
	return res
end
function cm.negop(e,tp,eg)
	eg:KeepAlive()
	cm.switch=eg
	local c=e:GetHandler()
	local s1=c:IsSummonable(true,nil,1)
	local s2=c:IsMSetable(true,nil,1)
	if (s1 and s2 and Duel.SelectPosition(tp,c,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
		Duel.Summon(tp,c,true,nil,1)
	else
		Duel.MSet(tp,c,true,nil,1)
	end
end
