--电子化冰刀手 紧身装束
local m=11451698
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	cm.AddFusionProcMix(c,97023549,11460577)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(cm.indcon)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.atkcon)
	e2:SetValue(cm.effectfilter)
	c:RegisterEffect(e2)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(cm.discon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
end
function cm.AddFusionProcMix(c,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local mat={}
	for i=1,#val do
		local code=val[i]
		mat[code]=true
	end
	if c.material==nil then
		local mt=getmetatable(c)
		mt.material=mat
	end
	for index,_ in pairs(mat) do
		aux.AddCodeList(c,index)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(cm.FConditionMix(...))
	e1:SetOperation(cm.FOperationMix(...))
	c:RegisterEffect(e1)
end
function cm.FConditionMix(...)
	local val={...}
	return  function(e,g,gc,chkfnf)
				local funs={}
				local sub=Duel.IsExistingMatchingCard(cm.ffilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
				for i=1,#val do
					local code=val[i]
					funs[i]=function(c,fc,sub) return c:IsFusionCode(code) or (sub and c:CheckFusionSubstitute(fc)) end
				end
				if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf&0x100>0
				local concat_fusion=chkfnf&0x200>0
				local sub=(sub or notfusion) and not concat_fusion
				local mg=g:Filter(aux.FConditionFilterMix,c,c,sub,concat_fusion,table.unpack(funs))
				if gc then
					if not mg:IsContains(gc) then return false end
					Duel.SetSelectedCard(Group.FromCards(gc))
				end
				return mg:CheckSubGroup(aux.FCheckMixGoal,#funs,#funs,tp,c,sub,chkfnf,table.unpack(funs))
			end
end
function cm.FOperationMix(...)
	local val={...}
	return  function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local funs={}
				local sub=Duel.IsExistingMatchingCard(cm.ffilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
				for i=1,#val do
					local code=val[i]
					funs[i]=function(c,fc,sub) return c:IsFusionCode(code) or (sub and c:CheckFusionSubstitute(fc)) end
				end
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf&0x100>0
				local concat_fusion=chkfnf&0x200>0
				local sub=(sub or notfusion) and not concat_fusion
				local mg=eg:Filter(aux.FConditionFilterMix,c,c,sub,concat_fusion,table.unpack(funs))
				if gc then Duel.SetSelectedCard(Group.FromCards(gc)) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:SelectSubGroup(tp,aux.FCheckMixGoal,false,#funs,#funs,tp,c,sub,chkfnf,table.unpack(funs))
				Duel.SetFusionMaterial(sg)
			end
end
function cm.ffilter(c)
	return c:IsCode(10248389) and c:IsFaceup()
end
function cm.indcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)==1
end
function cm.atkcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)==2
end
function cm.discon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)==3
end
function cm.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_PLAYER)
	return p==tp
end