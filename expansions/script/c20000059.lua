--幻梦龙 零
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm = self_table
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	aux.AddCodeList(c,20000050)
	fuef.I(c,c,",REC,PTG,E,,,bfgcost,tg1,op1")(nil,c,"SP,SP+DES,TG,P,m,,,tg2,op2")
end
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g,atk = fugf.GetFilter(tp,"M","IsFaceup"):GetMaxGroup(Card.GetBaseAttack)
	if chk==0 then return e:GetHandler():IsFaceup() and g and #g>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g,atk = fugf.GetFilter(p,"M+","IsFaceup"):GetMaxGroup(Card.GetBaseAttack)
	if #g==0 then return end
	Duel.Recover(p,atk,REASON_EFFECT)
end
--e2
function cm.tgf2(c,e,tp)
	return fucf.Filter(c,"TgChk+IsOTyp+(IsLoc/IsPos)",e,"M,M,FU") and fugf.GetFilter(tp,"D","IsCod+CanSp",{50,{e,tp,0,1}},1) 
		and Duel.GetMZoneCount(tp,c)>0 and c ~= e:GetHandler()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=fugf.GetFilter(tp,"MS",cm.tgf2,{e,tp})
	if chkc then return chkc:IsControler(tp) and g:IsContains(chkc) end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g = fugf.SelectTg(tp,"MS",cm.tgf2,{e,tp}) + e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) + e:GetHandler()
	if #tg~=2 or Duel.Destroy(tg,REASON_EFFECT)~=2 or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=fugf.SelectFilter(tp,"D","IsCod+CanSp",{50,{e,tp,0,1}},1):GetFirst()
	if not tc then return end
	Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
end