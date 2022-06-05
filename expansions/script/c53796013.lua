local m=53796013
local cm=_G["c"..m]
cm.name="怪医芙兰"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,cm.mfilter,2,63,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	if not cm.Frantic_Fran then
		cm.Frantic_Fran=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.chkop)
		Duel.RegisterEffect(ge1,0)
	end
end
cm[0]={0}
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(0,LOCATION_GRAVE,LOCATION_GRAVE)
	for tc in aux.Next(g) do
		local t,code=cm[0],tc:GetCode()
		if not SNNM.IsInTable(code,t) then table.insert(t,code) end
		cm[0]=t
	end
end
function cm.mfilter(c)
	local t=cm[0]
	return c:IsCode(table.unpack(t))
end
function cm.hspcheck(g,atk)
	if atk==0 then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(aux.GetCappedAttack,atk)
end
function cm.hspgcheck(atk)
	return  function(g)
				if atk==0 then return true end
				if g:GetSum(aux.GetCappedAttack)<=atk then return true end
				Duel.SetSelectedCard(g)
				return g:CheckWithSumGreater(aux.GetCappedAttack,atk)
			end
end
function cm.spfilter(c,e,tp)
	local g=Duel.GetMatchingGroup(function(c)return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_DESTROY) and c:IsCanOverlay() and c:GetAttack()>0 end,tp,LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_EXTRA,c)
	aux.GCheckAdditional=cm.hspgcheck(aux.GetCappedAttack(c))
	local res=g:CheckSubGroup(cm.hspcheck,1,#g,aux.GetCappedAttack(c))
	aux.GCheckAdditional=nil
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousLevelOnField()>0 and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsCanBeSpecialSummoned(e,0,c:GetPreviousControler(),false,false,c:GetPreviousPosition()) and ((not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(c:GetPreviousControler())>0) or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(c:GetPreviousControler(),c:GetReasonPlayer(),nil,c))) and res
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.spfilter,1,nil,e,tp) end
	local g=eg:Filter(cm.spfilter,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	local gg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #gg>0 then Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,gg,#gg,0,0) end
end
function cm.filter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,c:GetPreviousControler(),false,false,c:GetPreviousPosition()) and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(c:GetPreviousControler())>0) or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(c:GetPreviousControler(),c:GetReasonPlayer(),nil,c))
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.filter,nil,e,tp)
	if g:GetCount()==0 then return end
	local sc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if #g>1 then sc=g:Select(tp,1,1,nil):GetFirst() end
	Duel.SpecialSummon(sc,0,sc:GetPreviousControler(),sc:GetPreviousControler(),false,false,sc:GetPreviousPosition())
	if not sc:IsLocation(LOCATION_MZONE) then return end
	Duel.BreakEffect()
	local typ,otyp=sc:GetType(),sc:GetOriginalType()
	local ctyp=typ&(TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_MONSTER+TYPE_NORMAL)
	sc:SetCardData(4,typ-ctyp+TYPE_MONSTER+TYPE_XYZ)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetLabel(otyp)
	e1:SetLabelObject(sc)
	e1:SetOperation(cm.rstop)
	Duel.RegisterEffect(e1,tp)
	local mg=Duel.GetMatchingGroup(function(c)return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_DESTROY) and c:IsCanOverlay()end,tp,LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_EXTRA,nil):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	aux.GCheckAdditional=cm.hspgcheck(aux.GetCappedAttack(sc))
	local og=mg:SelectSubGroup(tp,cm.hspcheck,false,1,#mg,aux.GetCappedAttack(sc))
	aux.GCheckAdditional=nil
	if og then Duel.Overlay(sc,og) end
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local tc,typ=e:GetLabelObject(),e:GetLabel()
	if tc:IsLocation(LOCATION_MZONE) then return end
	tc:SetCardData(4,typ)
	e:Reset()
end
