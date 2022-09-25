--裁决的殿堂 辉煌家园
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000101") end) then require("script/c20000101") end
function cm.initial_effect(c)
	local e1={fu_judg.F(c)}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	a=a:IsControler(tp) and a or Duel.GetAttackTarget()
	return a:IsSummonType(SUMMON_TYPE_ADVANCE) and a:IsRelateToBattle() and a:IsStatus(STATUS_OPPO_BATTLE)
end
function cm.opf(c,tc)
	local g=Duel.GetTributeGroup(c):Filter(Card.IsControler,nil,c:GetControler())
	local min,max=c:GetTributeRequirement()
	return c:IsSummonable(true,nil,1) and g:IsContains(tc) and Duel.CheckTribute(c,minc,maxc,g)
end
function cm.opf2(g,rc,minc,maxc,tc)
	return Duel.CheckTribute(rc,minc,maxc,g) and (g:GetCount()>=minc and g:GetCount()<=maxc) and g:IsContains(tc)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	a=a:IsControler(tp) and a or Duel.GetAttackTarget()
	if Duel.IsExistingMatchingCard(cm.opf,tp,LOCATION_HAND,0,1,nil,a) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local c=Duel.SelectMatchingCard(tp,cm.opf,tp,LOCATION_HAND,0,1,1,nil,a):GetFirst()
		local g=Duel.GetTributeGroup(c):Filter(Card.IsControler,nil,tp)
		local min,max=c:GetTributeRequirement()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=g:SelectSubGroup(tp,cm.opf2,false,1,#g,c,min,max,a)
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
end