local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableReviveLimit()
	local mt=getmetatable(c)
	if mt.material_count==nil then mt.material_count={2,127} end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(s.fscon)
	e0:SetOperation(s.fsop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.atkcalc)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsControler(fc:GetControler()) and c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and (not sg or not sg:IsExists(function(c,att)return c:GetFusionAttribute()~=att end,1,c,c:GetFusionAttribute())) and not c:IsHasEffect(6205579)
end
function s.fcheck(sg,tp,fc,sub,chkfnf)
	local chkf=chkfnf&0xff
	local concat_fusion=chkfnf&0x200>0
	if not concat_fusion and sg:IsExists(aux.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not aux.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	local g=Group.CreateGroup()
	return sg:GetClassCount(Card.GetFusionAttribute)==#sg and not sg:IsExists(Card.IsHasEffect,1,nil,6205579) and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0) and (not aux.FCheckAdditional or aux.FCheckAdditional(tp,sg,fc)) and (not aux.FGoalCheckAdditional or aux.FGoalCheckAdditional(tp,sg,fc))
end
function s.fscon(e,g,gc,chkfnf)
	if g==nil then return Auxiliary.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
	if gc then return false end
	local c=e:GetHandler()
	local tp=c:GetControler()
	local notfusion=chkfnf&0x100>0
	local concat_fusion=chkfnf&0x200>0
	local sub2=notfusion and not concat_fusion
	local mg=g:Filter(aux.FConditionFilterMix,c,c,sub2,concat_fusion,s.ffilter)
	local sg=Group.CreateGroup()
	return mg:CheckSubGroup(s.fcheck,2,127,tp,c,sub2,chkfnf)
end
function s.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local c=e:GetHandler()
	local notfusion=chkfnf&0x100>0
	local concat_fusion=chkfnf&0x200>0
	local sub2=notfusion and not concat_fusion
	local mg=eg:Filter(aux.FConditionFilterMix,c,c,sub2,concat_fusion,s.ffilter)
	if gc then Duel.SetSelectedCard(gc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local sg=mg:SelectSubGroup(tp,s.fcheck,false,2,127,tp,c,sub2,chkfnf)
	Duel.SetFusionMaterial(sg)
end
function s.atkcalc(e,c)
	local multi=1
	local g=c:GetMaterial()
	if g:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_LIGHT) and g:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_EARTH) and g:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_WIND) then multi=multi*2 c:RegisterFlagEffect(0,RESET_EVENT+0xfe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1)) end
	if g:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_DARK) and g:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_WATER) and g:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_FIRE) then multi=multi*2 c:RegisterFlagEffect(0,RESET_EVENT+0xfe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2)) end
	if g:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_LIGHT) and g:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_DARK) and g:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_DIVINE) then multi=multi*2 c:RegisterFlagEffect(0,RESET_EVENT+0xfe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3)) end
	e:SetLabel(multi)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(e:GetLabelObject():GetLabel())
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
