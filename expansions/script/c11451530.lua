--星系守护神 南十字星神
--21.05.03
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return x,y
end
function cm.intersection(ac,bc,cc,dc,tp)
	local ax,ay=cm.xylabel(ac,tp)
	local bx,by=cm.xylabel(bc,tp)
	local cx,cy=cm.xylabel(cc,tp)
	local dx,dy=cm.xylabel(dc,tp)
	local dr=(by-ay)*(dx-cx)-(ax-bx)*(cy-dy)
	if dr==0 then return -1,-1 end
	local x=((bx-ax)*(dx-cx)*(cy-ay)+(by-ay)*(dx-cx)*ax-(dy-cy)*(bx-ax)*cx)/dr
	local y=-((by-ay)*(dy-cy)*(cx-ax)+(bx-ax)*(dy-cy)*ay-(dx-cx)*(by-ay)*cy)/dr
	return x,y
end
function cm.fselect(g,c,e,tp)
	if #g~=4 then return false end
	local ac=g:GetFirst()
	local bc=g:GetNext()
	local cc=g:GetNext()
	local dc=g:GetNext()
	local ins1x,ins1y=cm.intersection(ac,bc,cc,dc,tp)
	local ins2x,ins2y=cm.intersection(ac,cc,bc,dc,tp)
	local ins3x,ins3y=cm.intersection(ac,dc,bc,cc,tp)
	local zone1,zone2=0,0
	if (ins1y==1 and ins1x>=0 and math.floor(ins1x)==ins1x and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,tp,1<<ins1x)) then zone1=zone1|1<<ins1x end
	if (ins1y==3 and ins1x<=4 and math.floor(ins1x)==ins1x and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,1-tp,1<<(4-ins1x))) then zone2=zone2|1<<(4-ins1x) end
	if (ins2y==1 and ins2x>=0 and math.floor(ins2x)==ins2x and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,tp,1<<ins2x)) then zone1=zone1|1<<ins2x end
	if (ins2y==3 and ins2x<=4 and math.floor(ins2x)==ins2x and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,1-tp,1<<(4-ins2x))) then zone2=zone2|1<<(4-ins2x) end
	if (ins3y==1 and ins3x>=0 and math.floor(ins3x)==ins3x and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,tp,1<<ins3x)) then zone1=zone1|1<<ins3x end
	if (ins3y==3 and ins3x<=4 and math.floor(ins3x)==ins3x and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,1-tp,1<<(4-ins3x))) then zone2=zone2|1<<(4-ins3x) end
	if zone1==0 and zone2==0 then return false,0,0 end
	return true,zone1,zone2
end
function cm.tgfilter(c,e)
	return c:IsCanBeEffectTarget(e) --and not c:IsLocation(LOCATION_FZONE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
		return g:CheckSubGroup(cm.fselect,4,4,c,e,tp)
	end
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	local tg=g:SelectSubGroup(tp,cm.fselect,false,4,4,c,e,tp)
	Duel.SetTargetCard(tg)
	Duel.SetChainLimit(cm.chainlm)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,4,0,0)
end
function cm.chainlm(e,ep,tp)
	return tp==ep
end
function cm.nrfilter(c,e)
	return not c:IsRelateToEffect(e)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not c:IsRelateToEffect(e) or not tg or tg:IsExists(cm.nrfilter,1,nil,e) then return end
	local _,zone1,zone2=cm.fselect(tg,c,e,tp)
	local s1=c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,tp,zone1)
	local s2=c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,1-tp,zone2)
	local op=0
	if s1 and s2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif s1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	elseif s2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	else
		Duel.SelectOption(tp,aux.Stringid(m,2))
		return
	end
	local p=tp
	if op==1 then
		p=1-tp
		zone1=zone2
	end
	if Duel.SpecialSummon(c,0,tp,p,true,false,POS_FACEUP,zone1)>0 then
		c:CompleteProcedure()
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
	end
end