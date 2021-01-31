--文明裁决者 加拉特隆二型
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000090)
function cm.initial_effect(c)   
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2)
	local e1=rsef.FC(c,EVENT_CHAINING,nil,nil,"cd,uc,sa,ir",nil,cm.chainop)
	local e2=rsef.QO(c,nil,{m,0},{1,m},nil,nil,LOCATION_MZONE,cm.damcon,rscost.cost(Card.IsAbleToRemoveAsCost,"rm",LOCATION_GRAVE),rsop.target(Card.IsFaceup,nil,0,LOCATION_MZONE),cm.damop)
	local e3=rsef.FV_LIMIT(c,"dis",nil,nil,{ 0,LOCATION_ONFIELD },cm.dccon)
	local e4=rsef.SV_UPDATE(c,"atk",cm.val,cm.dccon)
	--extra material
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCondition(cm.linkcon)
	e5:SetOperation(cm.linkop)
	e5:SetValue(SUMMON_TYPE_LINK)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_EXTRA,0)
	e6:SetTarget(cm.mattg)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
function cm.lmfilter(c,lc,tp,og,lmat)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL)
		and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function cm.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return cm.lmfilter(e:GetHandler(),c,tp,og,lmat)
end
function cm.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	c:SetMaterial(e:GetHandler())
	Duel.SendtoGrave(e:GetHandler(),REASON_MATERIAL+REASON_LINK)
end
function cm.mattg(e,c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK) and c:IsLevelBelow(e:GetHandler():GetLink())
end
function cm.dccon(e)
	local c=e:GetHandler()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end
function cm.val(e,c)
	local bc=c:GetBattleTarget()
	local atk,def=bc:GetAttack(),bc:GetDefense()
	atk = atk or 0
	def = def or 0
	if atk<0 then atk =0 end
	if def<0 then def =0 end
	return math.min(atk,def)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()==e:GetHandler() then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.damcon(e,tp)
	return e:GetHandler():IsAttackPos()
end
function cm.damop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c or not c:IsAttackPos() then return end
	rsop.SelectSolve(HINTMSG_OPPO,tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil,cm.solvefun,c)
end
function cm.solvefun(g,c)
	Duel.CalculateDamage(c,g:GetFirst())
	return true
end