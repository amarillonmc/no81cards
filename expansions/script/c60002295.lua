if not pcall(function() require("expansions/script/c60002290") end) then require("script/c60002290") end
local cm,m=lanp.U("设置卡","黄昏+黄昏教廷","黄昏教廷教习·米兰")
dusk[m]={}
function cm.initial_effect(c)
    local e1=lane.I(c,c,{m,0},"TE+DR,,,E",m,cm.con,cm.cost,cm.tg,cm.op)
    local e2=lane.STO(c,c,{m,1},"TH,SS,DE",m+100,",",cm.tg1,cm.op3) and lane.STO(c,c,{m,1},"TH,SP,DE",m,",",cm.tg1,cm.op3)
    ------------------------
    aux.EnablePendulumAttribute(c)
    local e3=dusk.Pe(c,c)
    local e4=lane.I(c,c,{m,1},"TD+SH,,,P",m+1000,",",cm.tg2,cm.op4)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return lanc.Filter(c,"IsLoc+IsFaceup","E") and lang.Get(tp,"E"):GetCount()>=15
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return lang.GetFilter(tp,"H","IsDiscardable","",1) end
    lanp.U("提示","S",tp,"DC")
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local lg=lang.GetFilter(tp,"M","IsSeries+IsTyp","黄昏教廷,LINK")
    local c=e:GetHandler()
    local zone=0
	for tc in aux.Next(lg) do
        zone=bit.bor(zone,bit.band(tc:GetLinkedZone(),0x1f))
    end
    if chk==0 then return zone~=0 and lanc.Filter(c,"CanSp",{e,0,tp,false,false,POS_FACEUP,tp,zone}) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    lanp.U("连锁信息",0,"SP",c,1,tp,"0")
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local lg=lang.GetFilter(tp,"M","IsSeries+IsTyp","黄昏教廷,LINK")
    local zone=0
	for tc in aux.Next(lg) do
        zone=bit.bor(zone,bit.band(tc:GetLinkedZone(),0x1f))
    end
	if not c:IsRelateToEffect(e) or zone==0 then return false end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone) and Duel.GetFlagEffect(tp,m)==0 then
	    local e1=lane.FC(e,tp,"",EVENT_PREDRAW,",,",cm.con1,cm.op1,{RESET_PHASE+PHASE_END,3})
        local e2=lane.FC(e,tp,"",EVENT_CHAINING,",,",cm.con2,cm.op2,{RESET_PHASE+PHASE_END,3})
        table.insert(dusk.begin,e1)
        table.insert(dusk[m],c)
        table.insert(dusk[m],e1)
        table.insert(dusk[m],e2)
        lanp.U("标识",tp,m,RESET_PHASE+PHASE_END,0,3)
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=dusk[m][1]
    if lang.GetFilter(tp,"GD","IsSeries+AbleTo","黄昏,H",1) then
        lanp.U("提示","S",tp,"ATH")
        local g=lang.SelectFilter(tp,"GD","IsSeries+AbleTo","黄昏,H")
        if #g~=0 then
            if lanp.U("效果处理",Duel.SendtoHand,g,{tp,"EFF"})>0 then
                Duel.ConfirmCards(1-tp,g)
                if lanc.Filter(c,"IsLoc+CanSp",{"G/R",{e,0,tp}}) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
                    Duel.SpecialSummon(c,e,0,tp,false,false,POS_FACEUP)
                end
            end
        end
    end
    for i=1,#dusk[m] do
        if aux.GetValueType(dusk[m][i])=="Effect" then 
            dusk[m][i]:Reset() 
            dusk[m][i]=0
        end
    end
    for i=1,#dusk[m] do
        table.remove(dusk[m])
    end
    Duel.ResetFlagEffect(tp,m)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and lang.GetFilter(tp,"H","IsSeries+IsTyp+AbleTo","黄昏教廷,PE,E",1) and Duel.IsPlayerCanDraw(tp,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
    lanp.U("提示","S",tp,"TD")
    local g=lang.GetFilter(tp,"H","IsSeries+IsTyp+AbleTo","黄昏教廷,PE,E")
    if #g==0 then return false end
    if lanp.U("效果处理",Duel.SendtoExtraP,g,{nil,"EFF"})>0 and Duel.IsPlayerCanDraw(tp,1) then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return lang.GetFilter(tp,"E","IsSeries+IsTyp+AbleTo+IsFaceup","黄昏教廷,PE,H",1) end
   lanp.U("连锁信息",0,"TH",nil,1,tp,"E") 
end
function cm.op3(e,tp,eg,ev,ep,re,r,rp)
    lanp.U("提示","S",tp,"ATH")
    local g=lang.SelectFilter(tp,"E","IsSeries+IsTyp+AbleTo+IsFaceup","黄昏教廷,PE,H")
    if #g==0 then return false end
    if lanp.U("效果处理",Duel.SendtoHand,g,{tp,"EFF"})>0 then
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=lang.Get(tp,"HGD")
    if chk==0 then return g:CheckSubGroup(cm.f,2,2) end
    lanp.U("连锁信息",0,"TD",nil,1,tp,"H+G")
    lanp.U("连锁信息",0,"TH",nil,1,tp,"D")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=lang.Get(tp,"HGD")
    lanp.U("提示","S",tp,"SEL")
    g=g:SelectSubGroup(tp,cm.f,true,2,2,nil)
    local sg=lang.Filter(g,"IsLoc","D")
    lanp.U("效果处理",Duel.SendtoDeck,lang.Filter(g,"IsLoc/IsLoc","H,G"),{tp,2,"EFF"})
    if lanp.U("效果处理",Duel.SendtoHand,sg,{tp,"EFF"})>0 then
        Duel.ConfirmCards(1-tp,sg)
    end
end
function cm.f(g)
    return g:GetClassCount(Card.GetCode)~=1 and lang.Filter(g,"IsSeries+(IsLoc/IsLoc)+AbleTo","黄昏教廷,H,G,D",1) and lang.Filter(g,"IsSeries+IsLoc+AbleTo","黄昏教廷,D,H",1)
end