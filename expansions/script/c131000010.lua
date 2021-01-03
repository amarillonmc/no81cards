--Vivid BAD SQUAD 镜音连
local m=131000010
local cm=_G["c"..m]
function cm.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(131000010,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCondition(c131000010.spcon)
    e2:SetTarget(c131000010.sptg)
    e2:SetOperation(c131000010.spop)
    c:RegisterEffect(e2)
    --synchro limit

    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e1:SetValue(c131000010.synlimit)
    c:RegisterEffect(e1)
    --synchro level
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
    e3:SetTarget(c131000010.syntg)
    e3:SetValue(1)
    e3:SetOperation(c131000010.synop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(89818984)
    e4:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e4)
end

function c131000010.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)==0
        and Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE)>0
and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xacda)
end
function c131000010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c131000010.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c131000010.synlimit(e,c)
    if not c then return false end
    return not c:IsType(TYPE_PENDULUM) 
end
function c131000010.cardiansynlevel(c)
    return 2
end
function c131000010.synfilter(c,syncard,tuner,f)
    return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function c131000010.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
    g:AddCard(c)
    local ct=g:GetCount()
    local res=c131000010.syngoal(g,tp,lv,syncard,minc,ct)
        or (ct<maxc and mg:IsExists(c131000010.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
    g:RemoveCard(c)
    return res
end
function c131000010.syngoal(g,tp,lv,syncard,minc,ct)
    return ct>=minc and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
        and (g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
            or g:CheckWithSumEqual(c131000010.cardiansynlevel,lv,ct,ct,syncard))
end
function c131000010.syntg(e,syncard,f,min,max)
    local minc=min+1
    local maxc=max+1
    local c=e:GetHandler()
    local tp=syncard:GetControler()
    local lv=syncard:GetLevel()
    if lv<=c:GetLevel() and lv<=c131000010.cardiansynlevel(c) then return false end
    local g=Group.FromCards(c)
    local mg=Duel.GetMatchingGroup(c131000010.synfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
    return mg:IsExists(c131000010.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c131000010.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
    local minc=min+1
    local maxc=max+1
    local c=e:GetHandler()
    local lv=syncard:GetLevel()
    local g=Group.FromCards(c)
    local mg=Duel.GetMatchingGroup(c131000010.synfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
    for i=1,maxc do
        local cg=mg:Filter(c131000010.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
        if cg:GetCount()==0 then break end
        local minct=1
        if c131000010.syngoal(g,tp,lv,syncard,minc,i) then
            minct=0
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
        local sg=cg:Select(tp,minct,1,nil)
        if sg:GetCount()==0 then break end
        g:Merge(sg)
    end
    Duel.SetSynchroMaterial(g)
end
