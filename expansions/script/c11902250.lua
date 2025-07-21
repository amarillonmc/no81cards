--灾厄之种
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.sqfi5ter(c,e)
    return c:GetSequence()<5 and c:IsDestructable(e)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sqfi5ter,tp,0x0c,0,1,e:GetHandler(),e)
        and Duel.GetFlagEffect(tp,id)==0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0x0c)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,id)==0 then 
        Duel.RegisterFlagEffect(tp,id,nil,0,1)
    else return end
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.sqfi5ter,tp,0x0c,0,aux.ExceptThisCard(e),e)
   	if #g>0 then
        Duel.Hint(3,tp,502)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        local tc=sg:GetFirst()
        local seq=tc:GetSequence()
        local zone=0
        if seq<5 then
            if tc:IsControler(0) then
                if tc:IsLocation(0x04) then
                    zone=2^seq
                elseif tc:IsLocation(0x08) then
                    seq=2^seq
                    zone=seq*256
                end
            else
                if tc:IsLocation(0x04) then
                    seq=2^seq
                    zone=seq*65536
                elseif tc:IsLocation(0x08) then
                    seq=2^seq
                    zone=seq*16777216
                end
            end
        end
        if Duel.Destroy(tc,REASON_EFFECT)>0 and zone>0 then
            local fz=zone+111902250
            if Duel.GetFlagEffect(tp,fz)==0 then
                local e1=Effect.CreateEffect(c)
       		    e1:SetType(EFFECT_TYPE_FIELD)
       		    e1:SetCode(EFFECT_DISABLE_FIELD)
       		    e1:SetValue(zone)
        	    Duel.RegisterEffect(e1,tp)
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
                e2:SetCode(EVENT_CUSTOM+fz)
                e2:SetLabelObject(e1)
                e2:SetOperation(s.xxxop)
                Duel.RegisterEffect(e2,tp)
                Duel.RegisterFlagEffect(tp,fz,nil,0,1)
            end
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
            e1:SetCountLimit(1)
            e1:SetOperation(s.lcop)
            Duel.RegisterEffect(e1,tp)
        end
	end
end
function s.xxxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=e:GetLabelObject()
	e1:Reset()
	e:Reset()
end
function s.lcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
    local c=e:GetHandler()
    local LockZ=true
    local Val=1
    --GetZone
    if LockZ then
        local Met=0
        local Ct=true
        while Ct do
            local Zone_W,Zone_A,Zone_S,Zone_D=0,0,0,0
            local TM=2^Met
            local zone=Val*TM
            --LockCheck
            local fz=zone+111902250
            if Duel.GetFlagEffect(tp,fz)>0 then
                --ZoneW
                if Val==1 and (Met==1 or Met==3) then
                    if Met==1 then Zone_W=4194304
                    else Zone_W=2097152 end
                elseif Val==2097152 then Zone_W=131072
                elseif Val==4194304 then Zone_W=524288
                elseif Val~=16777216 then
                    if Val==256 then Zone_W=TM
                    elseif Val==65536 then Zone_W=16777216*TM end
                end
                if Zone_W>0 then
                    local f2=Zone_W+211902250
                    if Duel.GetFlagEffect(tp,f2)==0 then
                        Duel.RegisterFlagEffect(tp,f2,nil,0,1)
                    end
                end
                --ZoneA
                if (Val==1 or Val==256) and Met>0 then
                    local met=Met-1
                    tm=2^met
                    Zone_A=Val*tm
                elseif (Val==65536 or Val==16777216) and Met<4 then
                    local met=Met+1
                    tm=2^met
                    Zone_A=Val*tm
                end
                if Zone_A>0 then
                    local f2=Zone_A+211902250
                    if Duel.GetFlagEffect(tp,f2)==0 then
                        Duel.RegisterFlagEffect(tp,f2,nil,0,1)
                    end
                end
                --ZoneD
                if (Val==1 or Val==256) and Met<4 then
                    local met=Met+1
                    tm=2^met
                    Zone_D=Val*tm
                elseif (Val==65536 or Val==16777216) and Met>0 then
                    local met=Met-1
                    tm=2^met
                    Zone_D=Val*tm
                end
                if Zone_D>0 then
                    local f2=Zone_D+211902250
                    if Duel.GetFlagEffect(tp,f2)==0 then
                        Duel.RegisterFlagEffect(tp,f2,nil,0,1)
                    end
                end
                --ZoneS
                if Val==65536 and (Met==1 or Met==3) then
                    if Met==1 then Zone_S=2097152
                    else Zone_S=4194304 end
                elseif Val==2097152 then Zone_S=8
                elseif Val==4194304 then Zone_S=2
                elseif Val~=256 then
                    if Val==16777216 then Zone_S=65536*TM
                    elseif Val==1 then Zone_S=256*TM end
                end
                if Zone_S>0 then
                    local f2=Zone_S+211902250
                    if Duel.GetFlagEffect(tp,f2)==0 then
                        Duel.RegisterFlagEffect(tp,f2,nil,0,1)
                    end
                end
            end
            --Next
            if (Val==1 or Val==256) and Met<4 then
                Met=Met+1
            elseif (Val==65536 or Val==16777216) and Met>0 then
                Met=Met-1 
            else
                if Val==1 then Val=256
                elseif Val==256 then Val=2097152
                elseif Val==2097152 then Val=4194304
                elseif Val==4194304 then Val=65536
                elseif Val==65536 then Val=16777216
                else Ct=false end
                Met=0
                if (Val==65536 or Val==16777216) then
                    Met=4
                end
            end
        end
    end
    --ZoneLock
    local ZoneX=true
    Val=1
    if ZoneX then
        local Met,pl,ZonEX=0,0,0x04
        local Zx=true
        while Zx do
            local TM=2^Met
            local zone=Val*TM
            local fz=zone+111902250
            local f2=zone+211902250
            if Val==4194304 then Met=5 end
            if Val==2097152 then Met=6 end
            if Duel.GetFlagEffect(tp,fz)==0 and Duel.GetFlagEffect(tp,f2)>0 then
                Duel.ResetFlagEffect(tp,f2)
                if Duel.CheckLocation(pl,ZonEX,Met) then
                    local e1=Effect.CreateEffect(c)
       		        e1:SetType(EFFECT_TYPE_FIELD)
       		        e1:SetCode(EFFECT_DISABLE_FIELD)
       		        e1:SetValue(zone)
        	        Duel.RegisterEffect(e1,tp)
                    local e2=Effect.CreateEffect(c)
                    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
                    e2:SetCode(EVENT_CUSTOM+fz)
                    e2:SetLabelObject(e1)
                    e2:SetOperation(s.xxxop)
                    Duel.RegisterEffect(e2,tp)
                    Duel.RegisterFlagEffect(tp,fz,nil,0,1)
                end
            end
            if Met<5 then
                Met=Met+1
            else
                Met=0
                if Val==1 then Val,ZonEX=256,0x08
                elseif Val==256 then Val,ZonEX=2097152,0x04
                elseif Val==2097152 then Val=4194304
                elseif Val==4194304 then Val,pl,ZonEX=65536,1,0x04
                elseif Val==65536 then Val,ZonEX=16777216,0x08
                else Zx=false end
            end
        end 
    end
end