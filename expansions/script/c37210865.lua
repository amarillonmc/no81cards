--究极体 奥米加兽
local s,id,o=GetID()
function s.initial_effect(c)
     c:EnableReviveLimit()
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.sprcon)
    e0:SetTarget(s.sprtg)
	e0:SetOperation(s.sprop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
    --imdes
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
    --doubleatk
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e3)
    --des+ng/recover+damage
    local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.xyztg)
	e4:SetOperation(s.xyzop)
	c:RegisterEffect(e4)
end
function s.matfilter(c,xyzc)
    return (c:IsXyzLevel(xyzc,8) and c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc))
    or (c:IsXyzType(TYPE_XYZ) and c:IsFaceup() and c:IsAttackAbove(2500) and c:IsCanBeXyzMaterial(xyzc))
end
function s.sprcon(e,c,og,min,max)
    local c=e:GetHandler()
	if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
                local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_MZONE,0,nil,c)
    return mg:GetCount()>=2 and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
    local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_MZONE,0,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=mg:Select(tp,2,2,nil)
    if not g then return false end
    g:KeepAlive()
     e:SetLabelObject(g)
    return true
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
    local mat_g=e:GetLabelObject()
    c:SetMaterial(mat_g)
    local tc=mat_g:GetFirst()
    while tc do
        if tc:IsType(TYPE_XYZ) and tc:GetOverlayCount()>0 then
            Duel.Overlay(c,tc:GetOverlayGroup())
        end
        tc=mat_g:GetNext()
    end
    Duel.Overlay(c,mat_g)
    mat_g:DeleteGroup()
end

function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return  Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    local xyzcm=c:GetOverlayGroup():GetCount()
    local ct=math.floor(xyzcm/3)
    if sg then
        Duel.Destroy(sg,REASON_EFFECT)
        Duel.BreakEffect()
        if ct<=0 then return end
        for i=1,ct do
        local b1=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil)
        local b2=true
        local b3=i>1
        if not b1 and not b2  then break end
        local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2},
			{b3,aux.Stringid(id,3),3})
            if op==1 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
                local dng=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
                local ngtc=dng:GetFirst()
                if ngtc then
		            Duel.NegateRelatedChain(ngtc,RESET_TURN_SET)
		            local e1=Effect.CreateEffect(c)
            		e1:SetType(EFFECT_TYPE_SINGLE)
            		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            		e1:SetCode(EFFECT_DISABLE)
            		ngtc:RegisterEffect(e1)
            		local e2=Effect.CreateEffect(c)
              		e2:SetType(EFFECT_TYPE_SINGLE)
            		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	            	e2:SetCode(EFFECT_DISABLE_EFFECT)
	            	e2:SetValue(RESET_TURN_SET)
	            	ngtc:RegisterEffect(e2)
	                if ngtc:IsType(TYPE_TRAPMONSTER) then
	            		local e3=Effect.CreateEffect(c)
	            		e3:SetType(EFFECT_TYPE_SINGLE)
	            		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		            	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		        	ngtc:RegisterEffect(e3)
		            end
	            end
            end
            if op==2 then
	            if e:GetLabel()==0 then
		        Duel.Recover(tp,2000,REASON_EFFECT)
                if Duel.GetCurrentPhase()==PHASE_MAIN2 then
                    Duel.Damage(1-tp,1000,REASON_EFFECT)
                end
                end
            end
            if op==3 then
			break
		end
        end
    end
end