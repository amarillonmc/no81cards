--last upd 2022-1-12
Seine_SLM={}
local slm=_G["Seine_SLM"]
slm.arty=0x1313
slm.arcode=31408000
if not aux.link_mat_hack_check then
	aux.link_mat_hack_check=true
	_IsCanBeLinkMaterial=Card.IsCanBeLinkMaterial
	function Card.IsCanBeLinkMaterial(c,lc)
		if c:GetOriginalType()&TYPE_MONSTER~=0 then
			return _IsCanBeLinkMaterial(c,lc)
		end
		if c:IsForbidden() then return false end
		local le={c:IsHasEffect(EFFECT_CANNOT_BE_LINK_MATERIAL)}
		for _,te in pairs(le) do
			local tf=te:GetValue()
			local tval=tf(te,lc)
			if tval then return false end
		end
		return true
	end
end
if not aux.get_link_mat_hack_check then
	aux.get_link_mat_hack_check=true
	function aux.GetLinkMaterials(tp,f,lc,e)
		local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_ONFIELD,0,nil,f,lc,e)
		local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
		return mg
	end
end
function slm.linkMonster(c,linkmetnum,matfilter)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,matfilter,linkmetnum)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(slm.mattg)
	e1:SetValue(slm.matval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetProperty(EFFECT_FLAG_REPEAT)
	e2:SetOperation(slm.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_CANNOT_DISABLE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(0xac)
	e3:SetOperation(slm.op)
	c:RegisterEffect(e3)
end
function slm.mattg(e,c)
	return c:IsSetCard(slm.arty)
end
function slm.matval(e,lc,mg,c,tp)
	return false,true
end
function slm.disop(e,tp)
	local c=e:GetHandler()
	return c:GetLinkedZone()
end
function slm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_GRAVE) then
		if Duel.SendtoDeck(c,nil,0,REASON_EFFECT)>0 then
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
end
function slm.ST(c)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_CANNOT_DISABLE)
	e:SetCode(EVENT_ADJUST)
	return e
end
function slm.STact(c)
	local e=slm.ST(c)
	e:SetRange(0x27)
	e:SetOperation(slm.STactop)
	c:RegisterEffect(e)
end
function slm.STactop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	if c:IsPreviousLocation(LOCATION_GRAVE) and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
		if Duel.MoveToField(c,p,p,LOCATION_SZONE,POS_FACEUP,true) then
			local lp=Duel.GetLP(p)
			Duel.SetLP(p,lp-500)
		end
	end
end
function slm.STset(c,label)
	local e=slm.ST(c)
	e:SetRange(0x27)
	e:SetOperation(slm.STsetop)
	e:SetLabel(label)
	c:RegisterEffect(e)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(slm.setcon)
	if c:IsType(TYPE_TRAP) then
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	end
	if c:IsType(TYPE_QUICKPLAY) then
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	end
	c:RegisterEffect(e1)
end
function slm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(slm.arcode)>0
end
function slm.STsetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	if c:IsPreviousLocation(LOCATION_GRAVE) then
		if Duel.SSet(p,c)>0 then
			local lp=Duel.GetLP(p)
			if e:GetLabel()==0 then
				Duel.SetLP(p,lp-500)
			else
				Duel.SetLP(p,lp/2)
			end
			c:RegisterFlagEffect(slm.arcode,RESET_EVENT+RESETS_STANDARD,nil,1)
		end
	end
end
function slm.STtd(c)
	local e=slm.ST(c)
	e:SetRange(0x2e)
	e:SetOperation(slm.STtdop)
	c:RegisterEffect(e)
end
function slm.STtdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_GRAVE) then
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 then
			Duel.Recover(c:GetControler(),1000,REASON_EFFECT)
		end
	end
end