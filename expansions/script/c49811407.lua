--ユニフィケーション・ベクトル
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_FUSION_MATERIAL)
    e0:SetCondition(s.Unification_Vector_Fusion_Condition())
    e0:SetOperation(s.Unification_Vector_Fusion_Operation())
    c:RegisterEffect(e0)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_HAND,0,Duel.SendtoGrave,REASON_SPSUMMON+REASON_MATERIAL)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--spsummon cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_COST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCost(s.spcost)
	e2:SetOperation(s.spcop)
	c:RegisterEffect(e2)
	--spsummon and draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(s.drcost)
	e3:SetTarget(s.drtarget)
	e3:SetOperation(s.droperation)
	c:RegisterEffect(e3)
	--cannot activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(s.aclimit)
	c:RegisterEffect(e4)
end
function s.Unification_Vector_Fusion_Gcheck(g,fc,tp,chkf,gc)
    if g:IsExists(aux.TuneMagicianCheckX,1,nil,g,EFFECT_TUNE_MAGICIAN_F) then return false end
    if gc and not g:IsContains(gc) then return false end
    if aux.FCheckAdditional and not aux.FCheckAdditional(tp,g,fc)
        or aux.FGoalCheckAdditional and not aux.FGoalCheckAdditional(tp,g,fc) then return false end
    return g:GetClassCount(Card.GetFusionCode)==1
        and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,g,fc)>0)
end
function s.Unification_Vector_Fusion_Condition()
    return function(e,g,gc,chkf)
        if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
        local fc=e:GetHandler()
        local tp=e:GetHandlerPlayer()
        if gc then
            if not g:IsContains(gc) then return false end
			return g:Filter(Card.IsFusionType,nil,TYPE_MONSTER):CheckSubGroup(s.Unification_Vector_Fusion_Gcheck,2,99,fc,tp,chkf,gc)
        end
        return g:Filter(Card.IsFusionType,nil,TYPE_MONSTER):CheckSubGroup(s.Unification_Vector_Fusion_Gcheck,2,99,fc,tp,chkf,nil) and Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
    end
end
function s.Unification_Vector_Fusion_Operation()
    return function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
        local fc=e:GetHandler()
        local tp=e:GetHandlerPlayer()
		if not gc then
			gc=nil
		end
		local g=eg:Filter(Card.IsFusionType,nil,TYPE_MONSTER)
		local sg=g:SelectSubGroup(tp,s.Unification_Vector_Fusion_Gcheck,false,2,99,fc,tp,chkf,gc)
        Duel.SetFusionMaterial(sg)
    end
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.spcost(e,c,tp)
	return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
end
function s.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.mgfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,c,c:GetCode())
end
function s.fselect(g)
	return g:GetClassCount(Card.GetCode)==1
end
function s.drtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.mgfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if e:GetHandler():GetSequence()<5 then ft=ft+1 end
		return ft>=1 and g:CheckSubGroup(s.fselect,2,99)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,s.fselect,false,2,99)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,#sg-1,0,0)
end
function s.droperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
		and g:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false,POS_FACEUP_ATTACK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false,POS_FACEUP_ATTACK)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
			Group.Sub(g,sg)
			if #g>0 then
				if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT,tp) and Duel.IsPlayerCanDraw(tp,#g) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					Duel.BreakEffect()
					Duel.Draw(tp,#g,REASON_EFFECT)
				end
			end		
		end
	end
end
function s.aclimit(e,re,tp)
	local mg=e:GetHandler():GetMaterial()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetReason()&(REASON_MATERIAL)==(REASON_MATERIAL) and re:GetHandler():GetReasonCard()==e:GetHandler() and mg:IsContains(re:GetHandler())
end