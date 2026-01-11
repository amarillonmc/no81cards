--凶饿毒狂欲融合龙
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_FUSION_MATERIAL)
    e0:SetCondition(s.pluto_Fusion_Condition())
    e0:SetOperation(s.pluto_Fusion_Operation())
    c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+id)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,id+id+id)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.pluto_Fusion_Filter(c,mg,fc,tp,chkf,gc)
	if not (c:IsFusionSetCard(0x1046) and c:IsFusionType(TYPE_FUSION)) then return false end
    local g=mg:Filter(s.matfilter,c,tp)
    local res=g:CheckSubGroup(s.pluto_Fusion_Gcheck,2,99,fc,tp,c,chkf,gc)
    return res
end
function s.matfilter(c,tp)
    return c:IsFusionAttribute(ATTRIBUTE_DARK)
end
function s.pluto_Fusion_Gcheck(g,fc,tp,ec,chkf,gc)
    local sg=g:Clone()
    sg:AddCard(ec)
    if sg:IsExists(aux.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
    if gc and not sg:IsContains(gc) then return false end
    return g:IsExists(Card.IsFusionType,1,nil,TYPE_FUSION)
        and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
end
function s.pluto_Fusion_Condition()
    return function(e,g,gc,chkf)
            if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
            local fc=e:GetHandler()
            local tp=e:GetHandlerPlayer()
            if gc then
                if not g:IsContains(gc) then return false end
                return g:IsExists(s.pluto_Fusion_Filter,1,nil,g,fc,tp,chkf,gc)
            end
            return g:IsExists(s.pluto_Fusion_Filter,1,nil,g,fc,tp,chkf,nil)
        end
end
function s.pluto_Fusion_Operation()
    return function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
            local fc=e:GetHandler()
            local tp=e:GetHandlerPlayer()
            local fg=eg:Clone()
            local g=nil
            local sg=nil
            while not sg do
                if g then
                    fg:AddCard(g:GetFirst())
                end
                if gc then
                    if s.pluto_Fusion_Filter(gc,fg,fc,tp,chkf) then
                        g=Group.FromCards(gc)
                        fg:RemoveCard(gc)
                        local mg=fg:Filter(s.matfilter,fc,tp)
                        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
                        sg=mg:SelectSubGroup(tp,s.pluto_Fusion_Gcheck,false,2,99,fc,tp,g:GetFirst(),chkf,gc)
                    else
                        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
                        g=fg:FilterSelect(tp,s.pluto_Fusion_Filter,1,1,nil,fg,fc,tp,chkf,gc)
                        fg:Sub(g)
                        local mg=fg:Filter(s.matfilter,fc,tp)
                        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
                        sg=mg:SelectSubGroup(tp,s.pluto_Fusion_Gcheck,true,2,99,fc,tp,g:GetFirst(),chkf,gc)
                    end
                else
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
                    g=fg:FilterSelect(tp,s.pluto_Fusion_Filter,1,1,nil,fg,fc,tp,chkf,nil)
                    fg:Sub(g)
                    local mg=fg:Filter(s.matfilter,fc,tp)
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
                    sg=mg:SelectSubGroup(tp,s.pluto_Fusion_Gcheck,true,2,99,fc,tp,g:GetFirst(),chkf)
                end
            end
            g:Merge(sg)
            Duel.SetFusionMaterial(g)
        end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetHandler():GetMaterialCount()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,nil,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local ct=e:GetHandler():GetMaterialCount()
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
	local count=Duel.Destroy(g,REASON_EFFECT)
	if count>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,count*200,REASON_EFFECT)
	end
end
function s.disfilter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or aux.NegateMonsterFilter(c))
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,s.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_ATTACK)
		e0:SetValue(atk)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local code=tc:GetOriginalCodeRule()
		local cid=0
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EFFECT_CHANGE_CODE)
		e4:SetValue(code)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		end
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(id,3))
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e5:SetCode(EVENT_PHASE+PHASE_END)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCountLimit(1)
		e5:SetLabelObject(e1)
		e5:SetLabel(cid)
		e5:SetOperation(s.rstop)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e5)
	end
end
function s.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and rp==1-tp and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.Destroy(sg,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,4))then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,nil,tp,tp,false,false,POS_FACEUP)
	end
end
