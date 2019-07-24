--秋意渐浓的唐伞妖怪
function c1146018.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local val={aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WIND),aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE)} 
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub,mg,sg) return val[i](c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) end
		else
			fun[i]=function(c,fc,sub) return c:IsFusionCode(val[i]) or (sub and c:CheckFusionSubstitute(fc)) end
			table.insert(mat,val[i])
		end
	end
	if #mat>0 and c.material_count==nil then
		local mt=getmetatable(c)
		mt.material_count=#mat
		mt.material=mat
	end
	local mt=getmetatable(c)
	mt.material_count=2
	mt.material=mat
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c1146018.FConditionMix(false,true,table.unpack(fun)))
	e1:SetOperation(c1146018.FOperationMix(false,true,table.unpack(fun)))
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1146018,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c1146018.cost2)
	e2:SetTarget(c1146018.tg2)
	e2:SetOperation(c1146018.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1146018,1))
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c1146018.tg3)
	e3:SetOperation(c1146018.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e4:SetOperation(c1146018.op4)
	c:RegisterEffect(e4)
--
end
--
function c1146018.FSelectMix(c,tp,mg,sg,fc,sub,chkf,...)
	sg:AddCard(c)
	local res
	if sg:GetCount()<#{...} then
		res=mg:IsExists(c1146018.FSelectMix,1,sg,tp,mg,sg,fc,sub,chkf,...)
	else
		res=aux.FCheckMixGoal(sg,tp,fc,sub,chkf,...)
	end
	sg:RemoveCard(c)
	return res
end
--
function c1146018.FExtraMaterialFilter(c,fc)
	return c:IsCanBeFusionMaterial(fc) and c:IsFusionAttribute(ATTRIBUTE_WIND) and not c:IsHasEffect(6205579)
end
function c1146018.exzonefilter(c)
	return c:GetSequence()>4
end
--
function c1146018.FConditionMix(insf,sub,...)
	local funs={...}
	return
	function(e,g,gc,chkfnf)
		if g==nil then return insf and aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
		local chkf=chkfnf&0xff
		local c=e:GetHandler()
		local tp=c:GetControler()
		local notfusion=chkfnf>>8~=0
		local sub=sub or notfusion
		local mg=g:Filter(aux.FConditionFilterMix,c,c,sub,table.unpack(funs))
		local exg=Duel.GetMatchingGroup(c1146018.FExtraMaterialFilter,tp,LOCATION_DECK,0,mg,c)
		if #exg>0 and mg:IsExists(c1146018.exzonefilter,1,nil) then
			mg:Merge(exg)
		end
		if gc then
			if not mg:IsContains(gc) then return false end
			local sg=Group.CreateGroup()
			return c1146018.FSelectMix(gc,tp,mg,sg,c,sub,chkf,table.unpack(funs))
		end
		local sg=Group.CreateGroup()
		local res=mg:IsExists(c1146018.FSelectMix,1,nil,tp,mg,sg,c,sub,chkf,table.unpack(funs))
		return res
	end
end
--
function c1146018.exgfilter(c,exg)
	return exg:IsContains(c)
end
function c1146018.FOperationMix(insf,sub,...)
	local funs={...}
	return
	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
		local chkf=chkfnf&0xff
		local c=e:GetHandler()
		local tp=c:GetControler()
		local notfusion=chkfnf>>8~=0
		local sub=sub or notfusion
		local mg=eg:Filter(aux.FConditionFilterMix,c,c,sub,table.unpack(funs))
		local exg=Duel.GetMatchingGroup(c1146018.FExtraMaterialFilter,tp,LOCATION_DECK,0,mg,c)
		if #exg>0 and mg:IsExists(c1146018.exzonefilter,1,nil) then
			mg:Merge(exg)
		end
		local sg=Group.CreateGroup()
		if gc then sg:AddCard(gc) end
		while sg:GetCount()<#funs do 
			if #sg==1 and not sg:IsExists(c1146018.exzonefilter,1,nil) then
				mg:Sub(exg)
			end
			if sg:IsExists(c1146018.exgfilter,1,nil,exg) then
				mg=mg:Filter(c1146018.exzonefilter,nil)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g=mg:FilterSelect(tp,c1146018.FSelectMix,1,1,sg,tp,mg,sg,c,sub,chkf,table.unpack(funs))
			sg:Merge(g)
		end
		Duel.SetFusionMaterial(sg)
	end
end
--
function c1146018.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
--
function c1146018.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 and c:IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
--
function c1146018.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsControler(tp) then return end
	if Duel.GetMZoneCount(tp)<1 then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.MoveSequence(c,math.log(s,2))
	Duel.BreakEffect()
	Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
end
--
function c1146018.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetHandler():GetFlagEffect(1146018)~=0 then
		e:SetLabel(1)
		e:GetHandler():ResetFlagEffect(1146018)
	else
		e:SetLabel(0)
	end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
		and Duel.GetFlagEffect(tp,1146018)<1 end
	Duel.RegisterFlagEffect(tp,1146018,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if e:GetLabel()~=1 then
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	end
end
--
function c1146018.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	if g:GetCount()<1 then return end
	if e:GetLabel()==1 and Duel.SelectYesNo(tp,aux.Stringid(1146018,2)) then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	else
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
--
function c1146018.op4(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(1146018,0,0,0)
end
--
